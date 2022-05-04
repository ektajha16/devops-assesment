/*
 | --Create VPC
*/
resource aws_vpc this_vpc {

    cidr_block = var.in_vpc_cidr

    enable_dns_support   = true
    enable_dns_hostnames = true

    tags = {

        Name   = "vpc-${ var.in_ecosystem }-${ var.in_timestamp }"
        Desc   = "devops-assesment vpc"
    }
}

/*
  | --Create Public and Private Subnet
*/
  

resource aws_subnet private {

    count = var.in_num_private_subnets

    cidr_block        = cidrsubnet( var.in_vpc_cidr, var.in_subnets_max, count.index )
    availability_zone = element( data.aws_availability_zones.with.names, count.index )
    vpc_id            = aws_vpc.this_vpc.id

    map_public_ip_on_launch = false

    tags = {

        Name     = "Devops-asses-private-Subnet"
        Class    = var.in_ecosystem
        Instance = "${ var.in_ecosystem }-${ var.in_timestamp }"
        Desc     = "Private Subnet for devops assesment"
    }

}


resource aws_subnet public {

    count = var.in_num_public_subnets

    cidr_block        = cidrsubnet( var.in_vpc_cidr, var.in_subnets_max, var.in_num_private_subnets + count.index )
    availability_zone = element( data.aws_availability_zones.with.names, count.index )
    vpc_id            = aws_vpc.this_vpc.id

    map_public_ip_on_launch = true

    tags = {

        Name     = "Devops-asses-public-Subnet"
        Class    = var.in_ecosystem
        Instance = "${ var.in_ecosystem }-${ var.in_timestamp }"
        Desc     = "Public Subnet for devops assesment"
    }

}

/* SG creation */

####create sg group prod-web-servers  for port 80 and 443 (Q-A)

resource "aws_security_group" "prod-web-servers-sg" {
  name        = "prod-web-servers-sg"
  description = "security group for terraform"
  vpc_id      = aws_vpc.this_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
/* EC2 creation */

resource "aws_instance" "prod-web-server-1" {
  ami                    = "ami-0c293f3f676ec4f90"
  count                  = 1
  key_name               = "terraform"
  instance_type          = "t3.large"
  vpc_security_group_ids = [aws_security_group.prod-web-servers-sg.id]
  subnet_id              = aws_subnet.private.id
  tags= {
    Name = "prod-web-servers-2"
 }
}
