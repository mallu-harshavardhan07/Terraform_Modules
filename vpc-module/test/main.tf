module "main" {
  source = "../"
  project = "robo"
  env = "Dev"
  cidr_block = "10.0.0.0/16"
  public_cidr = ["10.0.1.0/24","10.0.2.0/24"]
  private_cidr = ["10.0.11.0/24","10.0.12.0/24"]
  database_cidr = ["10.0.21.0/24","10.0.22.0/24"]
}