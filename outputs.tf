# Output ECS Cluster Name
output "ecs_cluster_name" {
  description = "The name of the ECS Cluster"
  value       = aws_ecs_cluster.medusa_cluster.name
}

# Output ECS Service Name
output "ecs_service_name" {
  description = "The name of the ECS Service"
  value       = aws_ecs_service.medusa_service.name
}

# Output ECS Task Definition ARN
output "ecs_task_definition_arn" {
  description = "The ARN of the ECS Task Definition"
  value       = aws_ecs_task_definition.medusa_task.arn
}

# Output Security Group ID
output "security_group_id" {
  description = "The ID of the security group used for the ECS service"
  value       = aws_security_group.medusa_sg.id
}

# Output Subnets
output "subnets" {
  description = "The subnets used by the ECS tasks"
  value       = var.subnets
}

output "service_url" {
  description = "The URL or public IP address to access the Medusa backend"
  value       = coalesce(aws_lb.lb.dns_name, "No Load Balancer configured")
}
