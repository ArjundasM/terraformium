#Global Vars
aws_cluster_name = "dev"

#VPC Vars
aws_vpc_cidr_block = "20.0.0.0/16"

#specify subnets cidr, number of entries should be equal to number of entries in aws_avail_zones.
#cidr range should be in the range of vpc codr
aws_cidr_subnets_private = ["20.0.1.0/24","20.0.3.0/24"]
aws_cidr_subnets_public = ["20.0.2.0/24","20.0.4.0/24"]

default_tags = {
  Env = "dev"
  Product = "kubernetes"
}

#Specify the availability zones to create subnets, route tables and nat-gateway
#Specify atleast two entries for HA cluster configuration
aws_avail_zones=["us-west-2a","us-west-2b"]
