locals {
  prov_task_def_name = "kbot-tf"
}

resource "aws_ecr_repository" "proverbinatusbot" {
  name = "proverbinatusbot" # Naming my repository
}

resource "aws_ecs_task_definition" "kbot_task_definition" {
  family             = local.gb_task_def_name
  execution_role_arn = "arn:aws:iam::${local.id}:role/ecsTaskExecutionRole"
  memory             = 200
  cpu                = 0
  container_definitions = data.template_file.kbot_template.rendered
  tags = merge(
    local.common_tags,
    {
      Name = local.prov_task_def_name
    }
  )
}

resource "aws_ecs_service" "kbot_service" {
  name            = local.prov_task_def_name
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.kbot_task_definition.arn
  desired_count   = 1
}


data "aws_ssm_parameter" "kbot_token" {
  name = "TOKEN"
}

data "aws_ssm_parameter" "kbot_channel" {
  name = "MWM_CHANNEL_ID"
}

data "template_file" "kbot_template" {
  template = "${file("./templates/40k-bot-task.json.tpl")}"
  vars = {
    token = data.aws_ssm_parameter.kbot_token.arn
    ecr_repo = aws_ecr_repository.proverbinatusbot.repository_url
    name = local.prov_task_def_name
    channel_id = data.aws_ssm_parameter.kbot_channel.arn
  }
}