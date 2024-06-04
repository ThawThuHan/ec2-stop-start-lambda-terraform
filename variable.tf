variable "region" {
  type    = string
  default = "us-east-1"
}

variable "instance_ids" {
  type = set(string)
}

variable "stop_schedule_expression" {
  default = "cron(0 19 * * ? *)"
  type    = string
}

variable "start_schedule_expression" {
  default = "cron(0 7 * * ? *)"
  type    = string
}
