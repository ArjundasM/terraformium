#Global Vars
aws_cluster_name = "devtest"

#VPC Vars
aws_vpc_cidr_block = "20.0.0.0/16"
#aws_cidr_subnets_private = ["10.250.192.0/20","10.250.208.0/20"]
#aws_cidr_subnets_public = ["10.250.224.0/20","10.250.240.0/20"]

aws_cidr_subnets_private = ["20.0.1.0/24","20.0.3.0/24"]
aws_cidr_subnets_public = ["20.0.2.0/24","20.0.4.0/24"]

#Bastion Host
aws_bastion_size = "t2.medium"


#Kubernetes Cluster

aws_kube_master_num = 3
aws_kube_master_size = "t2.medium"

aws_etcd_num = 3
aws_etcd_size = "t2.medium"

aws_kube_worker_num = 2
aws_kube_worker_size = "t2.medium"

#Settings AWS ELB

aws_elb_api_port = 6443
k8s_secure_api_port = 6443
kube_insecure_apiserver_address = "0.0.0.0"

default_tags = {
#  Env = "devtest"
#  Product = "kubernetes"
}

aws_avail_zones=["us-west-2a","us-west-2b"]
inventory_file = "../../../inventory/hosts"