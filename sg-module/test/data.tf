data "aws_ssm_parameter" "vpc_id" {
  name = "/roboshop/env/vpc_id"
}