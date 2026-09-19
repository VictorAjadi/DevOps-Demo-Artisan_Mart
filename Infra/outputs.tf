# ==========================================================
# JENKINS OUTPUTS
# ==========================================================

output "jenkins_public_ip" {
  description = "Public IP of the Jenkins server"
  value       = aws_instance.jenkins_server.public_ip
}

output "jenkins_url" {
  description = "Jenkins web UI"
  value       = "http://${aws_instance.jenkins_server.public_ip}:8080"
}

output "jenkins_ssh_command" {
  description = "Ready-to-paste SSH command for Jenkins"
  value       = "ssh -i ${path.module}/artisans_mart_key_pair.pem ubuntu@${aws_instance.jenkins_server.public_ip}"
}

output "jenkins_initial_password_command" {
  description = "Run this over SSH to get the Jenkins unlock password"
  value       = "sudo cat /var/lib/jenkins/secrets/initialAdminPassword"
}


# ==========================================================
# WEB SERVER OUTPUTS
# ==========================================================

output "webserver_public_ip" {
  description = "Public IP of the Artisan Mart web server"
  value       = aws_instance.web_server.public_ip
}

output "webserver_ssh_command" {
  description = "Ready-to-paste SSH command for the web server"
  value       = "ssh -i ${path.module}/artisans_mart_key_pair.pem ubuntu@${aws_instance.web_server.public_ip}"
}