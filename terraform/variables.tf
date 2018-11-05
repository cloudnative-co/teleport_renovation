#=================================================
# Region
variable "region" {
  default = "ap-northeast-1"
}

#=================================================
# Cluster Name
variable "cluster_main_name" {
	default = "teleport-main"
}

variable "cluster_sub_name" {
  default = "teleport-sub"
}

#=================================================
# EC2

variable "ami_id" {
    type = "map"
    default = {
        ap-northeast-1 = "ami-0b47ed98608f1b8a4"
    }
}

variable "public_key" {
  default = ""
}

variable "proxy" {
    type = "map"
    default = {
				count = 1
        instance_type = "t2.micro"
				volume_size = 30
    }
}

variable "auth" {
    type = "map"
    default = {
				count = 1
        instance_type = "t2.micro"
				volume_size = 30
    }
}

variable "node" {
    type = "map"
    default = {
				count = 1
        instance_type = "t2.micro"
				volume_size = 30
    }
}

variable "bastion" {
    type = "map"
    default = {
				count = 1
        instance_type = "t2.micro"
				volume_size = 30
    }
}

variable "sub" {
    type = "map"
    default = {
        count = 1
        instance_type = "t2.micro"
        volume_size = 30
    }
}

variable "node_sub" {
    type = "map"
    default = {
        count = 1
        instance_type = "t2.micro"
        volume_size = 30
    }
}

#=================================================
# VPC

variable "vpc_cidr" {
  default = "172.31.0.0/16"
}

variable cidr_split {
    default = {
        public = 0
        protected = 2
        private = 4
    }
}

variable "ip_addresses_ssh" {
    default = [
      "0.0.0.0/0"
    ]
}


#=================================================
# Route53

variable "domain" {
  default = ""
}
