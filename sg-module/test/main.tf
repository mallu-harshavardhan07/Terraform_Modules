module "sg" {
  source = "../"
  project = "roboshop"
  env = "dev"
  sg_name = "frontend"
  sg_description = "prepaing for frontend"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
}