variable "app_port" {
  type    = number
  default = 8000
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "iam_instance_profile" {
  type        = string
  description = "El nombre del rol IAM provisto por AWS Learner Lab"
}