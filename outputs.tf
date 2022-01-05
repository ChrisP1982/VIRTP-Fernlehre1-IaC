output "vm0-url" {
  value = "http://${aws_instance.vm0.public_ip}:8080"
}

output "vm1-url" {
  value = "http://${aws_instance.vm1.public_ip}:8080"
}

output "vm2-url" {
  value = "http://${aws_instance.vm2.public_ip}:8080"
}