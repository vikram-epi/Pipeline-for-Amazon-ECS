# ECS CLUSTER
resource "aws_ecs_cluster" "ecs-cluster" {
  name = "clusterDev"
}

# TASK DEFINITION
resource "aws_ecs_task_definition" "task" {
  family                   = "HTTPserver"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = "${aws_iam_role.iam-role.arn}"

  container_definitions = jsonencode([
    {
      name   = "golang-container"
      image  = "public.ecr.aws/g2b6m8b9/hello_world:latest" #URI
      cpu    = 256
      memory = 512
      portMappings = [
        {
          containerPort = 5000
        }
      ]
    }
  ])
}

# ECS SERVICE
resource "aws_ecs_service" "svc" {
  name            = "golang-Service"
  cluster         = "${aws_ecs_cluster.ecs-cluster.id}"
  task_definition = "${aws_ecs_task_definition.task.id}"
  desired_count   = 2
  launch_type     = "FARGATE"


  network_configuration {
    subnets          = ["${aws_subnet.pub-subnets[0].id}", "${aws_subnet.pub-subnets[1].id}"]
    security_groups  = ["${aws_security_group.sg1.id}"]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = "${aws_lb_target_group.tg-group.arn}"
    container_name   = "golang-container"
    container_port   = "5000"
  }
}
