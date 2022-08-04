locals {
  reggie_task_def_name = "reggie-bot-tf"
}

resource "aws_ecr_repository" "reggie-bot-tf" {
  name = "hive-helper-reggie" # Naming my repository
}

resource "aws_ecs_task_definition" "reggie_task_definition" {
  family             = local.reggie_task_def_name
  execution_role_arn = "arn:aws:iam::${local.id}:role/ecsTaskExecutionRole"
  memory             = 512
  cpu                = 256
  container_definitions = data.template_file.reggie_template.rendered
  tags = merge(
    local.common_tags,
    {
      Name = local.reggie_task_def_name
    }
  )
}

resource "aws_ecs_service" "reggie_service" {
  name            = local.reggie_task_def_name
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.reggie_task_definition.arn
  desired_count   = 1
}

data "aws_ssm_parameter" "reggie_token" {
  name = "REGGIE_TOKEN"
}

data "template_file" "reggie_template" {
  template = "${file("./templates/reggie-bot-task.json.tpl")}"
  vars = {
    token = data.aws_ssm_parameter.reggie_token.arn
    ecr_repo = aws_ecr_repository.reggie-bot-tf.repository_url
    name = local.reggie_task_def_name
  }
}