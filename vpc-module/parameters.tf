resource "aws_ssm_parameter" "vpc_id" {
  name  = "/roboshop/env/vpc_id"
  type  = "String"
  value = aws_vpc.main.id
}