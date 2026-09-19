resource "aws_security_group" "jenkins_sg" {
  name        = "artisan_mart_jenkins_sg"
  description = "Security group for Jenkins CI server"
  vpc_id      = aws_vpc.artisan_mart_vpc.id

  # SSH access to Jenkins
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Jenkins web interface
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "artisan_mart_jenkins_sg"
  }
}