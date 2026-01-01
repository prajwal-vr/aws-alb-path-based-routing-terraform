output "red_instance_id" {
  value = aws_instance.red.id
}

output "blue_instance_id" {
  value = aws_instance.blue.id
}

output "red_public_ip" {
  value = aws_instance.red.public_ip
}

output "blue_public_ip" {
  value = aws_instance.blue.public_ip
}