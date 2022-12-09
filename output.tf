output "Subnet" {
  description = "VPC Subnet"
  value       = aws_instance.frontend.*.subnet_id
}

output "IPAddress" {
  description = "Public IP of the Instance"
  value       = aws_instance.frontend.*.public_ip
}

