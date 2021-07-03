
resource "aws_vpc" "quest-vpc" {
    cidr_block = "10.0.0.0/16"
    enable_dns_support = "true"
    enable_dns_hostnames = "true"
    enable_classiclink = "false"
    instance_tenancy = "default"

    tags = {
        Name = "quest-vpc"
    }
}

resource "aws_subnet" "quest-subnet-public-01" {
    vpc_id = "${aws_vpc.quest-vpc.id}"
    cidr_block = "10.0.1.0/24"
    map_public_ip_on_launch = "true"
    availability_zone = "us-west-2a"
    tags = {
        Name = "prod-subnet-public-01"
    }
}

resource "aws_subnet" "quest-subnet-public-02" {
    vpc_id = "${aws_vpc.quest-vpc.id}"
    cidr_block = "10.0.2.0/24"
    map_public_ip_on_launch = "true"
    availability_zone = "us-west-2b"
    tags = {
        Name = "prod-subnet-public-02"
    }
}

