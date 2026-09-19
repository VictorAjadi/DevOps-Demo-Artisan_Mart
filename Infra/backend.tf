terraform {
  backend s3 {
    bucket = "artisan-mart-app"
    region = "us-east-1"
    key = "jenkins-server/terraform.tfstate"
  }
}