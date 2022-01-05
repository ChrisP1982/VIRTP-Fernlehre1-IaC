# Data Source for getting Amazon Linux AMI
data "aws_ami" "amazon-2" {
  most_recent = true

  filter {
    name = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }
  owners = ["amazon"]
}

########################################################### vm0
resource "aws_instance" "vm0" {
  ami = data.aws_ami.amazon-2.id
  instance_type = "t3.micro"

  user_data = templatefile("${path.module}/templates/init_vm0.tpl", { 
    vm1_host = aws_instance.vm1.private_ip, 
    vm2_host = aws_instance.vm2.private_ip
  } )
 
  vpc_security_group_ids = [aws_security_group.ingress-all-ssh.id, aws_security_group.ingress-all-http.id]

  tags = {
    Name = "vm0"  
  }

  lifecycle {
    create_before_destroy = true
  }
}

########################################################### vm1
resource "aws_instance" "vm1" {
  ami = data.aws_ami.amazon-2.id
  instance_type = "t3.micro"

  user_data = templatefile("${path.module}/templates/init_vm1.tpl", { 
    vm1_index = "<html><head><meta http-equiv=\"refresh\" content=\"1\"></head><body><h1>data from vm1 is shown</body></html>" 
  } )

  vpc_security_group_ids = [aws_security_group.ingress-all-ssh.id, aws_security_group.ingress-all-http.id]

  tags = {
    Name = "vm1"  
  }

  lifecycle {
    create_before_destroy = true
  }
}

########################################################### vm2
resource "aws_instance" "vm2" {
  ami = data.aws_ami.amazon-2.id
  instance_type = "t3.micro"

  user_data = templatefile("${path.module}/templates/init_vm2.tpl", { 
    vm2_index = "<html><head><meta http-equiv=\"refresh\" content=\"1\"></head><body><h1>data from vm2 is shown</body></html>" 
  } )

  vpc_security_group_ids = [aws_security_group.ingress-all-ssh.id, aws_security_group.ingress-all-http.id]

  tags = {
    Name = "vm2"  
  }

  lifecycle {
    create_before_destroy = true
  }
}

########################################################### Security ###########################################################


resource "aws_security_group" "ingress-all-ssh" {
  name = "allow-all-ssh"
  ingress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    from_port = 22
    to_port = 22
    protocol = "tcp"
  }
  // Terraform removes the default rule
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "ingress-all-http" {
  name = "allow-all-http"
  ingress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
  }
  // Terraform removes the default rule
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

