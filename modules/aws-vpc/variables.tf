variable "aws_vpc_cidr_block" {
	description = "CIDR for vpc"
}

variable "aws_vpc_dns_support" {
	default = "true"
	description = "Enter true for dns support"
}

variable "aws_vpc_enable_hostname" {
	default = "true"
	description = "true - for enable hostname support"
}

variable "default_tags" {
	type = "map"
}
variable "aws_cidr_subnets_public" {
        description = "CIDR for public subnets"
	type = "list"
}
variable "aws_cluster_name" {
        description = "Cluster name"
}
variable "aws_cidr_subnets_private" {
	description = "CIDR for private subnets"
	type = "list"
}
variable "aws_avail_zones" {
    description = "AWS Availability Zones Used"
    type = "list"
}
