locals {
  gb_task_def_name = "gimme-bot-tf"
}

resource "aws_ecr_repository" "gimme-bot-tf" {
  name = "gimme-bot-tf" # Naming my repository
}

resource "aws_ecs_task_definition" "task_definition" {
  family             = local.gb_task_def_name
  execution_role_arn = "arn:aws:iam::${local.id}:role/ecsTaskExecutionRole"
  memory             = 200
  cpu                = 128 
  container_definitions = data.template_file.task_template_parameterstore.rendered
  tags = merge(
    local.common_tags,
    {
      Name = local.gb_task_def_name
    }
  )
}

resource "aws_ecs_service" "gbot_service" {
  name            = local.gb_task_def_name
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.task_definition.arn
  desired_count   = 1
}

data "aws_ssm_parameter" "gbot_token" {
  name = "BOT_TOKEN"
}

data "template_file" "task_template_parameterstore" {
  template = "${file("./templates/gimme-bot-task.json.tpl")}"
  vars = {
    token = data.aws_ssm_parameter.gbot_token.arn
    ecr_repo = aws_ecr_repository.gimme-bot-tf.repository_url
    name = local.gb_task_def_name
  }
}