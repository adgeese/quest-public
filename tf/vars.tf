variable "AWS_REGION" {
    default = "us-west-2"
}

variable "CLOUD_INIT_SOURCE" {
    default = "cloud_init.source"
}

variable "AWS_KEY" {
    default = "AKIAZTEUS7KQB3PLXEH7"
}

variable "AWS_SECRET" {
    default = "y3akplhOpaGkyMPYeZwF309TIwbBNk9n34ziM3gd"
}

variable "AMI" {
    # Linux 63-bit as your OS (Amazon Linux preferred)
    default = "ami-0721c9af7b9b75114"
}

variable "PRIVATE_KEY_PATH" {
  default = "quest-key-pair"
}

variable "PUBLIC_KEY_PATH" {
  default = "quest-key-pair.pub"
}

variable "EC2_USER" {
  default = "ec2-user"
}

