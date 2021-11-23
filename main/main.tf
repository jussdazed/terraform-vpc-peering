terraform {
  backend "s3" {
    bucket         = "dimka-state-storage"
    key            = "state/terraform.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "dimka-state-locks"
    encrypt        = true
  }
}

module "vpc-1" {
  source                 = "./modules/vpc"
  vpc_region             = "eu-central-1"
  cidr_block             = "10.0.0.0/16"
  vpc_name               = "mainVPC"
  subnet_cidr            = "10.0.10.0/24"
  ami                    = "ami-0bd99ef9eccfee250"
  peer_cidr_block        = module.vpc-2.cidr_block
  peering_id             = module.peering.peering_id
  destination_ping_route = ["172.16.0.0/16"]
}

module "vpc-2" {
  source                 = "./modules/vpc"
  vpc_region             = "eu-west-1"
  cidr_block             = "172.16.0.0/16"
  vpc_name               = "peerVPC"
  subnet_cidr            = "172.16.10.0/24"
  ami                    = "ami-09ce2fc392a4c0fbc"
  peer_cidr_block        = module.vpc-1.cidr_block
  peering_id             = module.peering.peering_id
  key_name               = "ireland-key"
  destination_ping_route = ["10.0.0.0/16"]
}

module "peering" {
  source         = "./modules/peering"
  request_region = module.vpc-1.region
  accept_region  = module.vpc-2.region
  request_vpc_id = module.vpc-1.vpc_id
  accept_vpc_id  = module.vpc-2.vpc_id
}
