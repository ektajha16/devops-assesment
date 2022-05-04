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
  user_data = << EOF
		#! /bin/bash
                sudo yum update -y
 sudo yum install -y httpd
 sudo systemctl enable httpd
 sudo service httpd start  
 sudo echo '<h1>OneMuthoot - APP-1</h1>' | sudo tee /var/www/html/index.html
 sudo mkdir /var/www/html/app1
 sudo echo '<!DOCTYPE html> <html> <body style="background-color:rgb(250, 210, 210);"> <h1>OneMuthoot - APP-1</h1> <p>Terraform Demo</p> <p>Application Version: V1</p> </body></html>' | sudo tee /var/www/html/app1/index.html
 sudo curl http://169.254.169.254/latest/dynamic/instance-identity/document -o /var/www/html/app1/metadata.html
	EOF
  tags= {
    Name = "prod-web-servers-1"
 }
}

/* create LB and attach to EC2 */


resource "aws_elb" "devops-asses" {
  name               = "devops-asses-terraform-elb"
  availability_zones = ["us-west-2a", "us-west-2b"]


  listener {
    instance_port     = 8080
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  listener {
    instance_port      = 8080
    instance_protocol  = "http"
    lb_port            = 443
    lb_protocol        = "https"
    ssl_certificate_id = "arn:aws:iam::123456789012:server-certificate/certName"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:8080/"
    interval            = 30
  }

  instances                   = [aws_instance.prod-web-server-1.id]
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags = {
    Name = "devops-asses-terraform-elb"
  }
}
