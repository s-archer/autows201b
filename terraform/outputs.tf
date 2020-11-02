output "f5-ami" {
  value = "Some other text with the AMI ID: ${data.aws_ami.f5_ami.id}"
}

output "f5_username" {
  value = "admin"
}

output "f5_password" {
  value = random_string.password.result
}

output "f5_ui" {
  value = "https://${aws_eip.mgmt.public_ip}"
}

output "f5_ssh" {
  value = "ssh admin@${aws_eip.mgmt.public_ip} -i ssh-key.pem"
}

output "f5_vs1" {
  value = [aws_eip.public-vs1.private_ip, aws_eip.public-vs1.public_ip]
}

output "f5_public_self" {
  value = aws_network_interface.public.private_ip
}

output "f5_private_self" {
  value = aws_network_interface.private.private_ip
}

output "f5_public_gw" {
  value = "10.0.2.1"
}

output "f5_private_gw" {
  value = "10.0.3.1"
}

output "consul_uri" {
  value = "http://${aws_instance.consul.public_ip}:8500"
}

output "consul_private_ip" {
  value = aws_instance.consul.private_ip
}