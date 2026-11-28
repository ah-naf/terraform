output "vpc_id" {
  value = aws_vpc.main.id
}

output "alb_public_dns" {
  value = aws_lb.main_alb.dns_name
}