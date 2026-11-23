resource "aws_route_table" "this" {
  for_each = var.route_tables
  vpc_id   = var.vpc_id

  route {
    cidr_block     = "0.0.0.0/0"
    gateway_id     = each.value.gateway_id
    nat_gateway_id = each.value.nat_gateway_id
  }

  tags = {
    Name = each.value.name
  }
}

resource "aws_route_table_association" "this" {
  for_each       = var.route_tables
  subnet_id      = var.subnet_ids[each.value.subnet_key]
  route_table_id = aws_route_table.this[each.key].id
}
