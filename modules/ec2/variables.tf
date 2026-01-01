variable "ami_id" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "iam_instance_profile" {
  type = string
}

variable "security_group_ids" {
  type = list(string)
}

variable "subnet_ids" {
  type = list(string)
}

variable "user_data_red" {
  type = string
}

variable "user_data_blue" {
  type = string
}