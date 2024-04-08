# --- ECS Task Definition ---
resource "aws_ecs_task_definition" "commit-backend" {
  family             = "commit-backend"
  task_role_arn      = aws_iam_role.ecs_task_role.arn
  execution_role_arn = aws_iam_role.ecs_exec_role.arn
  network_mode       = "awsvpc"
  cpu                = 256
  memory             = 256

  container_definitions = jsonencode([{
    name         = "commit-backend",
    image        = "docker.io/zivlederer/commit-backend:latest",
    essential    = true,
    portMappings = [{ containerPort = 5000, hostPort = 5000 }],

    environment = [
      { name = "DB_HOSTNAME", value = "${aws_db_instance.mysql.endpoint}" }
    ]

    logConfiguration = {
      logDriver = "awslogs",
      options = {
        "awslogs-region"        = "us-east-1",
        "awslogs-group"         = aws_cloudwatch_log_group.ecs.name,
        "awslogs-stream-prefix" = "backend-app"
      }
    },
  }])
}

# --- ECS Service ---
# security group for 
resource "aws_security_group" "ecs_backend_sg" {
  name_prefix = "ecs-task-sg-"
  description = "Allow all traffic within the VPC"
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [aws_vpc.my_vpc.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_ecs_service" "commit-backend" {
  name            = "commit-backend"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.commit-backend.arn
  desired_count   = 2

  network_configuration {
    security_groups = [aws_security_group.ecs_backend_sg.id]
    subnets         = [aws_subnet.private_subnet_1.id, aws_subnet.private_subnet_2.id]
  }

  capacity_provider_strategy {
    capacity_provider = aws_ecs_capacity_provider.main.name
    base              = 1
    weight            = 100
  }

  ordered_placement_strategy {
    type  = "spread"
    field = "attribute:ecs.availability-zone"
  }

  lifecycle {
    ignore_changes = [desired_count]
  }

  depends_on = [aws_db_instance.mysql]
}