#  SSH keys configurations
resource "aws_key_pair" "kp-1" {
  key_name   = "server_key"
  public_key = file("./my-key.pub")
}

# ---- EC2 Instances ----

resource "aws_instance" "vpc_2_instance" {
  ami           = var.app_ami_id
  instance_type = var.instance_type
  subnet_id     = aws_subnet.vpc_2_private_subnet.id
  key_name      = aws_key_pair.kp-1.key_name # Reference the key pair

  security_groups = [aws_security_group.app_sg_2.id]

  tags = var.tags
}

resource "aws_instance" "vpc_3_public_instance_1" {
  ami           = var.bastion_host_ami_id
  instance_type = var.instance_type
  subnet_id     = aws_subnet.vpc_3_public_subnet_1.id
  key_name      = aws_key_pair.kp-1.key_name # Reference the key pair

  security_groups = [aws_security_group.public_ec2_sg.id]


  tags                        = var.tags
  associate_public_ip_address = true
}


