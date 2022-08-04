variable "aws_region" {
  type        = string
  description = "The region in which to create and manage resources"
  default     = "ap-southeast-2"
}

variable "vpc_cidr" {
  default = "10.100.0.0/16"
}

variable "azs" {
  type = list(string)
  description = "the name of availability zones to use subnets"
  default = [ "ap-southeast-2a", "ap-southeast-2b" ]
}

variable "public_subnets" {
  type = list(string)
  description = "the CIDR blocks to create public subnets"
  default = [ "10.100.10.0/24", "10.100.20.0/24" ]
}

variable "private_subnets" {
  type = list(string)
  description = "the CIDR blocks to create private subnets"
  default = [ "10.100.30.0/24", "10.100.40.0/24" ]
}

variable "instance_type_spot" {
  default = "t3a.small"
  type    = string
}

variable "spot_bid_price" {
  default     = "0.0175"
  description = "How much you are willing to pay as an hourly rate for an EC2 instance, in USD"
}

variable "cluster_name" {
  default     = "ecs_discord_host"
  type        = string
  description = "the name of an ECS cluster"
}

variable "min_spot" {
  default     = "1"
  description = "The minimum EC2 spot instances to be available"
}

variable "max_spot" {
  default     = "1"
  description = "The maximum EC2 spot instances that can be launched at peak time"
}

variable "vpc_id" {
  default = "vpc-0c9f883314f174501"
  type = string
}