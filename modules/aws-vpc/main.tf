#Creating a VPC
resource "aws_vpc" "k8s-vpc" {
	cidr_block = "${var.aws_vpc_cidr_block}"
	enable_dns_support = "${var.aws_vpc_dns_support}"
	enable_dns_hostnames = "${var.aws_vpc_enable_hostname}"
	tags = "${merge(var.default_tags, map(
		"Name", "K8s-${var.aws_cluster_name}-vpc"))}"
}

#Creating elastic IP's
resource "aws_eip" "k8s-nat-eip" {
	count = "${length(var.aws_cidr_subnets_public)}"
	vpc = true
}

#Creating Internet-Gateway
resource "aws_internet_gateway" "k8s-gateway" {
	vpc_id = "${aws_vpc.k8s-vpc.id}"
	tags = "${merge(var.default_tags, map(
	"Name", "K8s-${var.aws_cluster_name}-igw"
	))}"
}

#Creating public subnet
resource "aws_subnet" "k8s-subnet-public" {
	vpc_id = "${aws_vpc.k8s-vpc.id}"
	count="${length(var.aws_avail_zones)}"
	availability_zone = "${element(var.aws_avail_zones, count.index)}"
	cidr_block = "${element(var.aws_cidr_subnets_public, count.index)}"
	tags = "${merge(var.default_tags, map(
	"Name", "K8s-${var.aws_cluster_name}-${element(var.aws_avail_zones, count.index)}-public"))}"
}

#Creating NAT gateway
resource "aws_nat_gateway" "k8s-nat-gateway" {
        count = "${length(var.aws_cidr_subnets_private)}"
        allocation_id = "${element(aws_eip.k8s-nat-eip.*.id, count.index)}"
        subnet_id = "${element(aws_subnet.k8s-subnet-public.*.id, count.index)}"
	tags {
		Name = "Nat-${element(aws_subnet.k8s-subnet-public.*.id, count.index)}"
}

}

#Creating private subnet
resource "aws_subnet" "k8s-subnet-private" {
	vpc_id = "${aws_vpc.k8s-vpc.id}"
	count = "${length(var.aws_avail_zones)}"
        availability_zone = "${element(var.aws_avail_zones, count.index)}"
	cidr_block = "${element(var.aws_cidr_subnets_private, count.index)}"
	tags = "${merge(var.default_tags, map(
	"Name", "K8s-${var.aws_cluster_name}-${element(var.aws_avail_zones, count.index)}-private"))}"
}

#Creating route table for public subnet and attaching to internet-gateway
resource "aws_route_table" "k8s-public" {
	vpc_id = "${aws_vpc.k8s-vpc.id}"
	route {
		cidr_block = "0.0.0.0/0"
		gateway_id = "${aws_internet_gateway.k8s-gateway.id}"
	}
	tags = "${merge(var.default_tags, map(
	"Name", "K8s-${var.aws_cluster_name}-${element(var.aws_avail_zones, count.index)}-route-public"))}"
}


#Creating route table for private subnet and attaching to NAT-getway
resource "aws_route_table" "k8s-private" {
	count = "${length(var.aws_cidr_subnets_private)}"
	vpc_id = "${aws_vpc.k8s-vpc.id}"
	route {
		cidr_block = "0.0.0.0/0"
		nat_gateway_id = "${element(aws_nat_gateway.k8s-nat-gateway.*.id, count.index)}"
	}
	tags = "${merge(var.default_tags, map(
	"Name", "K8s-${var.aws_cluster_name}-${element(var.aws_avail_zones, count.index)}-route-private"))}"
}

#Creating route table association for public subnet
resource "aws_route_table_association" "k8s-public" {
	count = "${length(var.aws_cidr_subnets_public)}"
	subnet_id = "${element(aws_subnet.k8s-subnet-public.*.id, count.index)}"
	route_table_id = "${aws_route_table.k8s-public.id}"
}

#Creating route table association for private subnets
resource "aws_route_table_association" "k8s-private" {
	count = "${length(var.aws_cidr_subnets_private)}"
	subnet_id = "${element(aws_subnet.k8s-subnet-private.*.id,count.index)}"
	route_table_id = "${element(aws_route_table.k8s-private.*.id,count.index)}"
}

#Creating security group
resource "aws_security_group" "kubernetes" {
	name = "k8s-${var.aws_cluster_name}-securitygroup"
	vpc_id = "${aws_vpc.k8s-vpc.id}"
	tags = "${merge(var.default_tags, map(
	"Name", "k8s-${var.aws_cluster_name}-securitygroup"))}"
         ingress {
                from_port = 0
                to_port = 0
                protocol = "-1"
                cidr_blocks = ["0.0.0.0/0"]
        }


        ingress {
                from_port = 0
                to_port = 0
                protocol = "-1"
                cidr_blocks= ["${var.aws_vpc_cidr_block}"]
        }
        egress {
                from_port = 0
                to_port = 0
                protocol ="-1"
                cidr_blocks = ["0.0.0.0/0"]
        }

}

