resource "aws_security_group" "alb_sg" {
  name        = "alb-sg"
  description = "Security group for ALB"
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb_target_group" "this" {
  for_each = toset(["web", "api"])

  name     = "${each.key}-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.my_vpc.id

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200-399"
  }
}

resource "aws_lb_target_group_attachment" "this" {
  for_each = local.servers

  target_group_arn = aws_lb_target_group.this[each.value.group].arn
  target_id        = aws_instance.this[each.key].id
  port             = 80
}

resource "aws_lb" "my_alb" {
    name = "my-alb"
    internal = false
    load_balancer_type = "application"
    security_groups = [aws_security_group.alb_sg.id]
    subnets = aws_subnet.public_subnets[*].id

    tags = {
        Name = "my-alb"
    }
}

resource "aws_lb_listener" "http_listener" {
    load_balancer_arn = aws_lb.my_alb.arn
    port              = 80
    protocol          = "HTTP"

    default_action {
        type             = "forward"
        target_group_arn = aws_lb_target_group.this["web"].arn
    }
}

# ?target=1 goes to the web target group, ?target=2 to the api target group.
# Anything else goes to the listener's default action (web).
resource "aws_lb_listener_rule" "target_param" {
  for_each = {
    "1" = { group = "web", priority = 1 }
    "2" = { group = "api", priority = 2 }
  }

  listener_arn = aws_lb_listener.http_listener.arn
  priority     = each.value.priority

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this[each.value.group].arn
  }

  condition {
    query_string {
      key   = "target"
      value = each.key
    }
  }
}