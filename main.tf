provider "aws" {
  region = var.aws_region
}

resource "aws_ecs_cluster" "medusa_cluster" {
  name = var.ecs_cluster_name
}

resource "aws_ecs_task_definition" "medusa_task" {
  family                   = var.ecs_task_family
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.task_cpu
  memory                   = var.task_memory
  
  container_definitions = <<DEFINITION
[
  {
    "name": "medusa",
    "image": "${var.container_image}",
    "essential": true,
    "portMappings": [
      {
        "containerPort": ${var.container_port},
        "hostPort": ${var.container_port}
      }
    ]
  }
]
DEFINITION

  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn      = aws_iam_role.ecs_task_execution_role.arn
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name = "medusaecsTaskExecutionRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}


resource "aws_iam_role_policy_attachment" "ecs_task_execution_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_ecs_service" "medusa_service" {
  name            = "medusa-service"
  cluster         = aws_ecs_cluster.medusa_cluster.id
  task_definition = aws_ecs_task_definition.medusa_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = var.subnets
    security_groups = [aws_security_group.medusa_sg.id]
  }
}

resource "aws_security_group" "medusa_sg" {
  name_prefix = var.security_group_name

  ingress {
    from_port   = var.container_port
    to_port     = var.container_port
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
# Define an Application Load Balancer (ALB)
resource "aws_lb" "lb" {
  name               = "medusa-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.medusa_sg.id]
  subnets            = var.subnets
}

# Define a Target Group for the ECS Service
resource "aws_lb_target_group" "tg" {
  name     = "medusa-tg"
  port     = var.container_port
  protocol = "HTTP"
  vpc_id   = "vpc-08a08cd882def8434" 
}

# Define a Listener for the Load Balancer
resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}
#testing with committing
