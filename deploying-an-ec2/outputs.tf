output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.this.id
}

output "public_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.this.public_ip
}

output "web_url" {
  description = "URL of the NGINX web server"
  value       = "http://${aws_instance.this.public_ip}"
}

output "ssh_command" {
  description = "Command to SSH into the instance"
  value       = "ssh -i ${trimsuffix(var.public_key_path, ".pub")} ubuntu@${aws_instance.this.public_ip}"
}
