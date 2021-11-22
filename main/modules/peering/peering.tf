provider "aws" {
  region = var.request_region
}

provider "aws" {
  alias  = "peer"
  region = var.accept_region
}

resource "aws_vpc_peering_connection" "peer" {
  vpc_id      = var.request_vpc_id
  peer_vpc_id = var.accept_vpc_id
  peer_region = var.accept_region
  auto_accept = false

  tags = {
    Side = "Requester"
  }
}

resource "aws_vpc_peering_connection_accepter" "peer" {
  provider                  = aws.peer
  vpc_peering_connection_id = aws_vpc_peering_connection.peer.id
  auto_accept               = true

  tags = {
    Side = "Accepter"
  }
}

output "peering_id" {
  value = aws_vpc_peering_connection.peer.id
}
