output "aws_vpc_id" {
	value = "${aws_vpc.k8s-vpc.id}"
}

output "aws_subnet_ids_private" {
	value = ["${aws_subnet.k8s-subnet-private.*.id}"]
}

output "aws_subnet_ids_public" {
	value = ["${aws_subnet.k8s-subnet-public.*.id}"]
}

output "aws_security_group" {
	value = ["${aws_security_group.kubernetes.*.id}"]
}

output "default_tags" {
	value = "${var.default_tags}"
