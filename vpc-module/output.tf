output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet" {
  value = aws_subnet.public_subnet[*].id
}
output "private_subnet" {
  value = aws_subnet.private[*].id
}

output "database_subnet" {
  value = aws_subnet.database[*].id
}