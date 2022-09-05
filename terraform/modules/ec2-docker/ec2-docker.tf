data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "ec2_docker" {
  ami             = data.aws_ami.ubuntu.id
  instance_type   = var.ec2_instance_type
  subnet_id       = var.subnet_id
  placement_group = var.cluster_pg_id

  tags = {
    Name = "${var.env_prefix}-${var.hostname}-ec2"
  }

  # To increase from default of 8GB
  root_block_device {
    volume_size           = 30
    encrypted             = false
    delete_on_termination = true
  }

  key_name = var.key_name

  associate_public_ip_address = true
  vpc_security_group_ids      = [var.security_group_id, var.private_security_group_id]

  provisioner "file" {
    source      = "${path.module}/docker-run.sh"
    destination = "/tmp/docker-run.sh"
  }

  provisioner "file" {
    source      = "${path.module}/startJFRAfterProvisioning.sh"
    destination = "/tmp/startJFRAfterProvisioning.sh"
  }

  provisioner "file" {
    source      = "${path.module}/restartJahiaAfterProvisioning.sh"
    destination = "/tmp/restartJahiaAfterProvisioning.sh"
  }

  # Wait for EFS volume to resolve before starting
  provisioner "file" {
    source      = "${path.module}/efs-wait.sh"
    destination = "/tmp/efs-wait.sh"
  }
  provisioner "remote-exec" {
    inline = [
      "sudo chmod +x /tmp/efs-wait.sh",
      "/tmp/efs-wait.sh ${var.efs_dns_name}",
    ]
  }

  # Set hostname, needed for nmon charts not to display the IP
  provisioner "remote-exec" {
    inline = [
      "sudo hostnamectl set-hostname --static ${var.hostname}",
    ]
  }

  # Set environment variables via bashrc
  provisioner "remote-exec" {
    inline = [
      "echo 'export NEXUS_USERNAME=${var.NEXUS_USERNAME}' >> /home/ubuntu/.bashrc-new",
      "echo 'export NEXUS_PASSWORD=${var.NEXUS_PASSWORD}' >> /home/ubuntu/.bashrc-new",
      "echo 'export DOCKERHUB_USERNAME=${var.DOCKERHUB_USERNAME}' >> /home/ubuntu/.bashrc-new",
      "echo 'export DOCKERHUB_PASSWORD=${var.DOCKERHUB_PASSWORD}' >> /home/ubuntu/.bashrc-new",
      "echo 'export JAHIA_LICENSE=${var.JAHIA_LICENSE}' >> /home/ubuntu/.bashrc-new",
      "echo 'export DOCKER_RUN_ENV=${base64encode(var.docker_run_env)}' >> /home/ubuntu/.bashrc-new",
      "echo 'export DOCKER_RUN_CMD=${base64encode(var.docker_run_cmd)}' >> /home/ubuntu/.bashrc-new",
      "echo 'export DOCKER_RUN_IMAGE=${base64encode(var.docker_run_image)}' >> /home/ubuntu/.bashrc-new",
      "echo 'export HOSTNAME=${var.hostname}' >> /home/ubuntu/.bashrc-new",
      "echo 'export SERVER_NAME=${var.server_name_jahia_private}' >> /home/ubuntu/.bashrc-new",
      "echo 'export PREFIX=${var.env_prefix}' >> /home/ubuntu/.bashrc-new",
      "echo 'export PERF_TESTS_START_INFRA_ONLY=${var.PERF_TESTS_START_INFRA_ONLY}' >> /home/ubuntu/.bashrc-new",
      "cat /home/ubuntu/.bashrc >> /home/ubuntu/.bashrc-new",
      "mv /home/ubuntu/.bashrc-new /home/ubuntu/.bashrc"
    ]
  }

  # Install all of the necessary tools to run the VM
  # https://github.com/hashicorp/terraform/issues/1025
  provisioner "remote-exec" {
    inline = [
      "sudo apt update",
      "sudo apt -yq upgrade",
      "sudo apt -yq install apt-transport-https ca-certificates curl software-properties-common libnfs-utils nfs-common nmon",
      "mkdir /home/ubuntu/data",
      # https://docs.aws.amazon.com/efs/latest/ug/troubleshooting-efs-mounting.html#automount-fails
      "sudo mount -t nfs -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport ${var.efs_dns_name}:/  /home/ubuntu/data",
      "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -",
      "sudo add-apt-repository \"deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable\"",
      "sudo apt update",
      "sudo apt -yq install docker-ce",
      "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -",
      "sudo usermod -aG docker ubuntu",
      # Set vm.max_map_count
      "sudo sysctl -w vm.max_map_count=262144",
      # Configure rsyslog
      "touch /home/ubuntu/data/artifacts/${var.env_prefix}-${var.hostname}.log.txt",
      "sudo usermod -a -G adm ubuntu",
      "sudo chown -vR syslog:adm /home/ubuntu/data/artifacts/${var.env_prefix}-${var.hostname}.log.txt",
      "echo 'if $syslogtag contains \"docker\" then /home/ubuntu/data/artifacts/${var.env_prefix}-${var.hostname}.log.txt'  | sudo tee -a /etc/rsyslog.d/50-default.conf",
      "sudo service rsyslog restart",
      "mkdir -p /home/ubuntu/data/artifacts/results/${var.hostname}",
      # Capture system health metrics every 10s
      "mkdir -p /home/ubuntu/data/artifacts/nmon",
      "nmon -f -s 5 -r ${var.hostname} -F /home/ubuntu/data/artifacts/nmon/${var.env_prefix}-${var.hostname}.nmon",
    ]
  }

  # copy public ssh key
  provisioner "remote-exec" {
    inline = [
      "mkdir -p ~/.ssh && touch ~/.ssh/authorized_keys && chmod -R go= ~/.ssh && printf '%b\n' '${join("\n", var.ssh_allowed_pub_keys)}' >> ~/.ssh/authorized_keys",
    ]
  }

  # Wait for provisioning to start JFR on Jahia nodes
  #nohup is mandatory as we want this process to keep running when this ssh session end
  provisioner "remote-exec" {
    inline = [
      "set -o errexit",
      "set -o nounset",
      "echo Start Docker",
      "sudo chmod +x /tmp/docker-run.sh",
      "echo execute docker command in background",
      "nohup bash /tmp/docker-run.sh > /home/ubuntu/data/artifacts/docker-exec-${var.env_prefix}-${var.hostname}.txt 2>&1 &",
      "echo Waiting for provisioning to be done",
      "sudo chmod +x /tmp/startJFRAfterProvisioning.sh",
      "nohup bash -c '/tmp/startJFRAfterProvisioning.sh ${var.hostname} \"${var.cron}\" \"${var.PERF_TESTS_JAHIA_JFR_RUN}\"' > /home/ubuntu/data/artifacts/start-jfr-${var.env_prefix}-${var.hostname}.txt 2>&1 &",
      "sudo chmod +x /tmp/restartJahiaAfterProvisioning.sh",
      "nohup bash -c '/tmp/restartJahiaAfterProvisioning.sh' > /home/ubuntu/data/artifacts/restart-jahia-${var.env_prefix}-${var.hostname}.txt 2>&1 &",
      "sleep ${var.sleep}"
    ]
  }

  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ubuntu"
    private_key = var.ssh_private_key
  }

}

resource "aws_route53_record" "ec2_docker_a_record_public" {
  zone_id = var.zone_id_public
  name    = var.server_name_jahia_public
  type    = "A"
  ttl     = "300"
  records = [aws_instance.ec2_docker.public_ip]
}

resource "aws_route53_record" "ec2_docker_a_record_private" {
  zone_id = var.zone_id_private
  name    = var.server_name_jahia_private
  type    = "A"
  ttl     = "300"
  records = [aws_instance.ec2_docker.private_ip]
}
