# Define the AWS region
variable "aws_region" {
  description = "The AWS region where resources will be created."
  type        = string
  default     = "us-east-1"
}

# Define the ECS cluster name
variable "ecs_cluster_name" {
  description = "The name of the ECS cluster."
  type        = string
  default     = "medusa-cluster"
}

# Define the ECS task family name
variable "ecs_task_family" {
  description = "The family name for the ECS task definition."
  type        = string
  default     = "medusa-task"
}

# Define the container image
variable "container_image" {
  description = "The container image to use for the Medusa service."
  type        = string
  default     = "medusajs/medusa:v1.4.0"
}

# Define the container port
variable "container_port" {
  description = "The port on which the Medusa container listens."
  type        = number
  default     = 9000
}

# Define CPU and memory for the Fargate task
variable "task_cpu" {
  description = "The amount of CPU to allocate to the Fargate task."
  type        = string
  default     = "512"
}

variable "task_memory" {
  description = "The amount of memory to allocate to the Fargate task."
  type        = string
  default     = "1024"
}

# Define VPC subnets
variable "subnets" {
  description = "A list of subnets where ECS tasks will run."
  type        = list(string)
  default     = ["subnet-0a044fda974f92d5b", "subnet-0a0f031fdc6225420"]
}

# Define security group
variable "security_group_name" {
  description = "Name prefix for the security group."
  type        = string
  default     = "medusa-sg"
}


