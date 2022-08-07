locals {
  regina_task_def_name = "regina-bot-tf"
}

resource "aws_ecr_repository" "regina-bot-tf" {
  name = "hive-helper-regina" # Naming my repository
}

resource "aws_ecs_task_definition" "regina_task_definition" {
  family             = local.regina_task_def_name
  execution_role_arn = "arn:aws:iam::${local.id}:role/ecsTaskExecutionRole"
  memory             = 200
  cpu                = 128 
  container_definitions = data.template_file.regina_template.rendered
  tags = merge(
    local.common_tags,
    {
      Name = local.regina_task_def_name
    }
  )
}

resource "aws_ecs_service" "regina_service" {
  name            = local.regina_task_def_name
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.regina_task_definition.arn
  desired_count   = 1
}

data "aws_ssm_parameter" "regina_token" {
  name = "REGINA_TOKEN"
}

data "template_file" "regina_template" {
  template = "${file("./templates/reggie-bot-task.json.tpl")}"
  vars = {
    token = data.aws_ssm_parameter.regina_token.arn
    ecr_repo = aws_ecr_repository.regina-bot-tf.repository_url
    name = local.regina_task_def_name
  }
}