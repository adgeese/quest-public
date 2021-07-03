
resource "aws_internet_gateway" "quest-igw" {
    vpc_id = "${aws_vpc.quest-vpc.id}"
    tags = {
        Name = "quest-igw"
    }
}

resource "aws_route_table" "quest-public-crt" {
    vpc_id = "${aws_vpc.quest-vpc.id}"

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.quest-igw.id}"
    }

    tags = {
        Name = "quest-public-crt"
    }
}

resource "aws_route_table_association" "quest-crta-public-subnet-01"{
    subnet_id = "${aws_subnet.quest-subnet-public-01.id}"
    route_table_id = "${aws_route_table.quest-public-crt.id}"
}

resource "aws_route_table_association" "quest-crta-public-subnet-02"{
    subnet_id = "${aws_subnet.quest-subnet-public-02.id}"
    route_table_id = "${aws_route_table.quest-public-crt.id}"
}

resource "aws_security_group" "ssh-http-allowed" {
    vpc_id = "${aws_vpc.quest-vpc.id}"

    egress {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        Name = "ssh-http-allowed"
    }
}


