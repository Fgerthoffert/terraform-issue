resource "aws_key_pair" "ec2_key_deployer" {
  key_name   = "${var.env_prefix}-ec2_key_deployer"
  public_key = var.ssh_pub_key
}

resource "aws_placement_group" "perf_group" {
  name     = "${var.env_prefix}-ec2_pg"
  strategy = "cluster"
}
