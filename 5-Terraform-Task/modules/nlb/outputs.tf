# NLB Outputs

output "nlb_dns_name" {
  description = "DNS name of the NLB"
  value       = aws_lb.test_nlb.dns_name
}

output "nlb_target_group_arn" {
  description = "ARN of the NLB target group"
  value       = aws_lb_target_group.test_nlb_target_group.arn
}

output "nlb_listener_arn" {
  description = "ARN of the NLB listener"
  value       = aws_lb_listener.test_nlb_listener.arn
}
