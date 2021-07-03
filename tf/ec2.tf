
resource "aws_instance" "quest" {
    ami = "${var.AMI}"
    instance_type = "t2.micro"
    subnet_id = "${aws_subnet.quest-subnet-public-01.id}"
    vpc_security_group_ids = ["${aws_security_group.ssh-http-allowed.id}"]
    key_name = "${aws_key_pair.quest-key-pair.id}"
    user_data = "${file("scripts/nginx.sh")}"

    connection {
        type        = "ssh"
        user        = "${var.EC2_USER}"
        private_key = "${file("${var.PRIVATE_KEY_PATH}")}"
        host        = "quest-public-01"
        timeout     = "20m"
    }
}

resource "null_resource" "quest" {
  provisioner "remote-exec" {
    connection {
      host = aws_instance.quest.public_dns
      user = "${var.EC2_USER}"
      private_key = file("${var.PRIVATE_KEY_PATH}")
      timeout     = "20m"
    }

    inline = [
        "echo 'connected!'",
        "nohup sudo yum install -y git go &",
        "sleep 30",
        "nohup sudo amazon-linux-extras install -y docker &",
        "sleep 30",
        "sudo usermod -a -G docker ${var.EC2_USER}",
        "sudo service docker start",
        "echo Downloading the Quest Application image..",
        "mkdir ~/.aws; echo '[default]' > ~/.aws/config",
        "echo 'region=us-west-2' >> ~/.aws/config",
        "echo 'output=json' >> ~/.aws/config",
        "echo '[default]' > ~/.aws/credentials",
        "echo 'aws_access_key_id=${var.AWS_KEY}' >> ~/.aws/credentials",
        "echo 'aws_secret_access_key=${var.AWS_SECRET}' >> ~/.aws/credentials",
        "aws ecr get-login-password --region us-west-2 | sudo docker login --username AWS --password-stdin 659589102240.dkr.ecr.us-west-2.amazonaws.com",
        "nohup sudo docker pull 659589102240.dkr.ecr.us-west-2.amazonaws.com/quest:latest &",
        "sleep 30",
        "echo Starting the quest application from docker to port 80",
        "nohup sudo docker run -d -p 80:3000 -it 659589102240.dkr.ecr.us-west-2.amazonaws.com/quest:latest &",
        "sudo curl -L https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose",
        "sudo chmod +x /usr/local/bin/docker-compose",
        "git clone https://github.com/suyashkumar/ssl-proxy.git",
        "cd ~/ssl-proxy; make",
        "echo Create the SSL Certificate for microhedg.es",
        "cd ~/ssl-proxy; timeout 200 nohup sudo ./ssl-proxy -d -from 0.0.0.0:4443 -to 127.0.0.1:3000 -domain=microhedg.es &",
        "cd ~/ssl-proxy; sleep 30; sudo chmod 777 *.pem",
        "echo Upload the new SSL Certificate",
        "echo Copy the cert.pem to the chain.crt, maybe split at the sep",
        #"aws iam upload-server-certificate --server-certificate-name microhedg.es --certificate-chain file://chain.crt --certificate-body file://cert.pem  --private-key file://key.pem"
        # "Create a Load Balancer Target Group",
        #"aws elbv2 create-target-group --name target-quest --protocol HTTP --port 3000 --vpc-id ${aws_vpc.quest-vpc.id}"
        #"echo Register this instance with the target group",
        #"aws elbv2 register-targets --target-group-arn targetgroup-arn --targets Id=i-0abcdef1234567890",
        #"echo Create a load balancer to the target group",
        #"aws elbv2 create-load-balancer --name quest-alb --type application --subnets subnet-0e3f5cac72EXAMPLE",
    ]
  }
}

resource "aws_key_pair" "quest-key-pair" {
    key_name = "quest-key-pair"
    public_key = "${file(var.PUBLIC_KEY_PATH)}"
}
