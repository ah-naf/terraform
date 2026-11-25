resource "aws_key_pair" "this" {
  key_name   = var.key_name
  public_key = file(var.public_key_path)
}

resource "aws_instance" "this" {
  for_each = var.instances

  ami                         = var.ami_id
  instance_type               = coalesce(each.value.instance_type, var.instance_type)
  key_name                    = aws_key_pair.this.key_name
  subnet_id                   = each.value.subnet_id
  vpc_security_group_ids      = each.value.security_group_ids
  associate_public_ip_address = each.value.associate_public_ip_address

  tags = {
    Name = each.value.name
  }
}
