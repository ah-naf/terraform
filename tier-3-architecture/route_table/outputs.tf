output "route_table_ids" {
  description = "Route table IDs, keyed like var.route_tables"
  value       = { for k, rt in aws_route_table.this : k => rt.id }
}
