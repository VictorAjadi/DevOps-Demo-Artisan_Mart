data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}


# ==========================================================
# SSH KEY
# ==========================================================

# Generate a secure RSA private key
resource "tls_private_key" "artisan_mart_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Create AWS Key Pair using the generated public key
resource "aws_key_pair" "artisan_mart_key" {
  key_name   = var.key_pair_name
  public_key = tls_private_key.artisan_mart_key.public_key_openssh
}

# Save private key locally for SSH
resource "local_sensitive_file" "artisan_mart_ssh_key" {
  filename        = "${path.module}/artisans_mart_key_pair.pem"
  content         = tls_private_key.artisan_mart_key.private_key_pem
  file_permission = "0400"
}


# ==========================================================
# JENKINS SERVER
# ==========================================================

resource "aws_instance" "jenkins_server" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type

  key_name = aws_key_pair.artisan_mart_key.key_name

  subnet_id = aws_subnet.artisan_mart_subnet.id

  vpc_security_group_ids = [
    aws_security_group.jenkins_sg.id
  ]

  # The subnet determines the Availability Zone.
  # No need to specify availability_zone here.

  associate_public_ip_address = true

  # user_data = file("${path.module}/ansible-configuration.sh")
  #
  # user_data_replace_on_change = true

  root_block_device {
    volume_size           = 30
    volume_type           = "gp3"
    delete_on_termination = true
    encrypted             = true
  }

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required" # IMDSv2 only
  }

  tags = {
    Name = "artisan_mart_jenkins_server"
    Role = "jenkins"
  }
}