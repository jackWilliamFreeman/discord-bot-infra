locals {
  service_port = 80
  ssh_port = 22
  
}


module "ec2_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name   = "ec2_sg"
  vpc_id = var.vpc_id

  ingress_with_cidr_blocks = [
    {
      from_port   = local.service_port #80
      to_port     = local.service_port #80
      protocol    = "tcp"
      description = "http port"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = local.ssh_port #22
      to_port     = local.ssh_port #22
      protocol    = "tcp"
      description = "ssh port"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
  egress_with_cidr_blocks = [
    {
      from_port = 0
      to_port   = 0
      protocol  = "-1"
    cidr_blocks = "0.0.0.0/0" }
  ]
}

resource "aws_launch_configuration" "ecs_config_launch_config_spot" {
  name_prefix                 = "${var.cluster_name}_ecs_cluster_spot"
  image_id                    = "ami-0a5d07e2b337abadb"
  instance_type               = var.instance_type_spot
  associate_public_ip_address = true
  lifecycle {
    create_before_destroy = true
  }
  user_data = <<EOF
#!/bin/bash
echo ECS_CLUSTER=${var.cluster_name} >> /etc/ecs/ecs.config
EOF

  security_groups = [module.ec2_sg.security_group_id]
  iam_instance_profile = aws_iam_instance_profile.ecs_agent.arn
}

resource "aws_autoscaling_group" "ecs_cluster_spot" {
  name_prefix = "${var.cluster_name}_asg_spot_"
  termination_policies = [
     "OldestInstance" 
  ]
  default_cooldown          = 30
  health_check_grace_period = 30
  max_size                  = var.max_spot
  min_size                  = var.min_spot
  desired_capacity          = var.min_spot

  launch_configuration      = aws_launch_configuration.ecs_config_launch_config_spot.name

  lifecycle {
    create_before_destroy = true
  }
  vpc_zone_identifier = ["subnet-01e6e566739c1187b", "subnet-02ad3ddfd6d92b00e"]

  tags = [
    {
      key                 = "Name"
      value               = var.cluster_name,

      propagate_at_launch = true
    }
  ]
}

resource "aws_ecs_cluster" "ecs_cluster" {
    name  = var.cluster_name
}