resource "aws_instance" "web_server" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type

  key_name = aws_key_pair.artisan_mart_key.key_name

  subnet_id = aws_subnet.artisan_mart_subnet.id

  vpc_security_group_ids = [
    aws_security_group.webserver_sg.id
  ]

  associate_public_ip_address = true

  root_block_device {
    volume_size           = 30
    volume_type           = "gp3"
    delete_on_termination = true
    encrypted             = true
  }

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  tags = {
    Name = "artisan_mart_web_server"
    Role = "webserver"
  }
}