output "ec2_public_ip" {
  value = aws_instance.petproject-app-instance.public_ip
}
