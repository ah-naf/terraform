provider "aws" {
  region = "ap-southeast-1"
}

resource "aws_instance" "web_server" {
  ami           = "ami-060e277c0d4cce553"  # This should be a valid AMI for your region.
  instance_type = "t2.micro"
  subnet_id     = "subnet-02d29458df29583cd" 

  provisioner "local-exec" {
    # command = "echo ${self.public_ip} > /invalid_path/web_server_ip.txt"
    command = "echo ${self.public_ip} > /tmp/web_server_ip.txt"
  }
}

# terraform taint <reource_type.resource_name>
# terraform untaint <resource_type.resource_name>

# Both terraform taint and terraform untaint are deprecated in modern Terraform workflows.
# HashiCorp recommends using terraform apply -replace instead of manually tainting resources.

# The removed block removes a resource from Terraform management.
# With destroy = true, Terraform destroys the actual infrastructure and removes it from state.
# This is NOT a direct replacement for taint/untaint.
# To replace a resource (previously done using terraform taint), use:
# terraform apply -replace="aws_instance.web_server"
# To cancel a pending replacement (previously done using terraform untaint),
# remove the -replace option and run terraform plan again.
# Use removed with destroy = false when you want to stop managing a resource
# without destroying the actual infrastructure.

removed {
  from = aws_instance.web_server

  lifecycle {
    destroy = true
  }
}