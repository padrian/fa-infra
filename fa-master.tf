# Configure the AWS Provider
provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "${var.region}"
}

locals {
  master_node = "fa-master"
  cluster_name = "dev_cluster"
  s3_bucket_name = "emirates-terraform-state"
}

terraform {
  backend "s3" {
    bucket = "emirates-terraform-state"
    key    = "fa-tf-state"
    region = "us-east-2"

    #dynamodb_table = "" used for tfstate locks
  }
}

data "terraform_remote_state" "k8s_cluster" {
  backend = "s3"

  config {
    bucket = "emirates-terraform-state"
    region = "us-east-2"
    key    = "fa-tf-state"
  }
}

resource "aws_security_group" "fa_sg" {
  name        = "fa_sg"
  description = "Allow Specific inbound traffic for security group"
  //vpc_id      = "${var.vpc_id}"
  vpc_id      = ""

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 31080
    to_port     = 31080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 31868
    to_port     = 31868
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 30461
    to_port     = 30461
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
    //prefix_list_ids = ["pl-12c4e678"]
  }
}

# Create a Future Airlines Master Node
resource "aws_instance" "k8s_master" {
  # ...
  ami               = "${var.master_ami}"
  instance_type     = "t2.large"
  availability_zone = "us-east-2b"
  vpc_security_group_ids = ["${aws_security_group.fa_sg.id}"]
  key_name = "padrian-us-east-2-key"

  tags = {
    Name = "future_airlines_master"
  }
  provisioner "file" {
    source      = "scripts"
    destination = "/tmp/"

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = "${file("padrian-us-east-2-key.pem")}"
    }
  }
  provisioner "remote-exec" {

    inline = [
      "sudo chmod -R 755 /tmp/scripts",
      "sudo /tmp/scripts/setup_master.sh"    
    ]
    connection {
      type     = "ssh"
      user     = "ubuntu"
      private_key = "${file("padrian-us-east-2-key.pem")}"
    }

  }

  //depends_on = [aws_security_group.fa_sg]
}
