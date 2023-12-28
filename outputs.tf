output "alb_dns" {
  value = aws_lb.app-lb.dns_name
}
