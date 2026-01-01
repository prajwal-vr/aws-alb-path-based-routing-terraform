resource "aws_instance" "red" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_ids[0]
  vpc_security_group_ids = var.security_group_ids
  iam_instance_profile   = var.iam_instance_profile
  user_data              = var.user_data_red
  associate_public_ip_address = true

  tags = {
    Name = "Red"
  }
}

resource "aws_instance" "blue" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_ids[1]
  vpc_security_group_ids = var.security_group_ids
  iam_instance_profile   = var.iam_instance_profile
  user_data              = var.user_data_blue
  associate_public_ip_address = true

  tags = {
    Name = "Blue"
  }
}