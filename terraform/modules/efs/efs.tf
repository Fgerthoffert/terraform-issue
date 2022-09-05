resource "aws_efs_file_system" "efs" {
  tags = {
    "Name" = "${var.env_prefix}-efs"
  }
  performance_mode = "maxIO"
}

resource "aws_efs_mount_target" "mount" {
  file_system_id  = aws_efs_file_system.efs.id
  subnet_id       = var.subnet_id
  security_groups = [var.security_group_id]
}
