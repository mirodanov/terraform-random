provider "aws" {
  region = "us-west-2" # Change to your desired AWS region
}

resource "aws_vpc" "example" {
  cidr_block = "10.1.0.0/16"
}

resource "aws_subnet" "example" {
  vpc_id                  = aws_vpc.example.id
  cidr_block              = "10.1.1.0/24"
  availability_zone       = "us-west-2a" # Change to your desired availability zone
  map_public_ip_on_launch = true
}

resource "aws_customer_gateway" "example" {
  type    = "ipsec.1"
  bgp_asn = 65000 # Your ASN

  tags = {
    Name = "example-customer-gateway"
  }
}

resource "aws_vpn_gateway" "example" {
  vpc_id = aws_vpc.example.id

  tags = {
    Name = "example-vpn-gateway"
  }
}

resource "aws_vpn_connection" "example" {
  customer_gateway_id = aws_customer_gateway.example.id
  vpn_gateway_id     = aws_vpn_gateway.example.id
  type               = "ipsec.1"
  static_routes_only = true

  tunnel1 {
    pre_shared_key = "your-pre-shared-key"
    tunnel_inside_cidr = "10.1.1.0/24" # Change to your subnet CIDR
    tunnel1_inside_cidr = "192.168.1.0/24" # Your Azure VNet CIDR
  }

  tunnel2 {
    pre_shared_key = "your-pre-shared-key"
    tunnel_inside_cidr = "10.1.1.0/24" # Change to your subnet CIDR
    tunnel2_inside_cidr = "192.168.2.0/24" # Another Azure VNet CIDR if needed
  }

  tags = {
    Name = "example-vpn-connection"
  }
}
