output "public" {
    value = ["${aws_instance.sample.*.public_ip}"]
} 
