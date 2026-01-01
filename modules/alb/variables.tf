variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "security_group_ids" {
  type = list(string)
}

variable "red_instance_id" {
  type = string
}

variable "blue_instance_id" {
  type = string
}