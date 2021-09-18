# output "ami" {
#   description = "Output ami_id after creating the ami"
#   value       = aws_instance.public_instance[count.index].id
# }
output "public_instance_id" {
  value = aws_instance.public_instance.id
}
