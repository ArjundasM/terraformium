provider "aws" {
	region = "ap-northeast-1"
	profile = "${var.profile}"	
}


#Creating new VPC
resource "aws_vpc" "vpc" {
	cidr_block ="10.0.0.0/16"
}
#Creating a new gateway 
resource "aws_internet_gateway" "internet_gateway" {
	vpc_id = "${aws_vpc.vpc.id}"
}

#Create new route
resource "aws_route" "internet_access" {
	route_table_id = "${aws_vpc.vpc.main_route_table_id}"
	destination_cidr_block ="0.0.0.0/0"
	gateway_id = "${aws_internet_gateway.internet_gateway.id}"
}

#Subnet for launching instances
resource "aws_subnet" "public" {
	vpc_id = "${aws_vpc.vpc.id}"
	cidr_block = "10.0.1.0/24"
	map_public_ip_on_launch = true
	tags {
		Name = "public"
	}
}

#Creating security group
resource "aws_security_group" "test" {
	name = "Terrafrom_security_group"
	description = "for public instances"
	vpc_id = "${aws_vpc.vpc.id}"
	
	ingress {
		from_port = 0
		to_port = 0
		protocol = "-1"
		cidr_blocks = ["115.110.193.6/32"]
	}

	ingress {
                from_port = 0
                to_port = 0
                protocol = "-1"
                cidr_blocks = ["10.0.1.0/24"]
        }

	
	ingress {
                from_port = 0
                to_port = 0
                protocol = "-1"
                cidr_blocks = ["49.204.92.182/32"]
        }

	
	ingress {
		from_port = 22
		to_port = 22
		protocol = "tcp"
		cidr_blocks = ["49.204.92.182/32"]
	}
	
	egress {
		from_port = 0 
		to_port = 0
		protocol ="-1"
		cidr_blocks = ["0.0.0.0/0"]
	}

}
# Creating keypair 
resource "aws_key_pair" "auth" {
	key_name = "${var.key_name}"
	public_key = "${file(var.public_key_path)}"
}

# Creating an instance
resource "aws_instance" "sample" {
	instance_type = "t2.medium"
	ami = "ami-be4a24d9"
	count ="${var.number_of_instances}"
	
	key_name = "${aws_key_pair.auth.id}"
	vpc_security_group_ids = ["${aws_security_group.test.id}"]
	subnet_id = "${aws_subnet.public.id}"
	tags {
		Name = "example-${count.index}"
	}	
	connection {
		user = "ubuntu"
	}

# provisioner "local-exec" {
#	command = "echo  \"[webserver]\n${aws_instance.sample.public_ip}\" > private_ips.txt"
#  }

#provisioner "local-exec" {
#	command = "echo [${aws_instance.sample.*.public_ip}] >> server1.txt"
#}


}


