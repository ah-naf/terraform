# Canonical publishes the current AMI ID per region in SSM
data "aws_ssm_parameter" "ubuntu" {
  name = "/aws/service/canonical/ubuntu/server/24.04/stable/current/amd64/hvm/ebs-gp3/ami-id"
}

resource "aws_key_pair" "this" {
  key_name   = var.key_name
  public_key = file(var.public_key_path)
}

resource "aws_instance" "this" {
  for_each = var.instances

  ami                         = coalesce(var.ami_id, data.aws_ssm_parameter.ubuntu.value)
  instance_type               = coalesce(each.value.instance_type, var.instance_type)
  key_name                    = aws_key_pair.this.key_name
  subnet_id                   = each.value.subnet_id
  vpc_security_group_ids      = each.value.security_group_ids
  associate_public_ip_address = each.value.associate_public_ip_address

  tags = {
    Name = each.value.name
  }
}
