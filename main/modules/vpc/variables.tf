variable "vpc_region" {

}
variable "cidr_block" {
}

variable "vpc_name" {
}

variable "subnet_cidr" {
}
variable "ami" {
}

variable "peer_cidr_block" {
}

variable "peering_id" {
}
variable "key_name" {
  default = "dima-key-frankfurt"
}

variable "destination_ping_route" {}
