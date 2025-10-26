variable "project"  {
    type = string
    description = "This is the name of the project"

}
variable "env" {
  type = string
  description = "This is Dev Environment."
}
variable "cidr_block" {
  type= string
}
variable "public_cidr" {
  type = list(string)
}
variable "private_cidr" {
  type = list(string)
}

variable "database_cidr" {
  type = list(string)
}
