resource "aws_security_group" "my-sg" {
  vpc_id = var.vpc_id
  name = "mysecurity"
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [var.ingress-ip]
  }

  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    prefix_list_ids = []
  }

  tags = {
      Name = "${var.env_tag}-sg"
   }
}



data "aws_ami" "latest-amazon-linux" {
  most_recent = true
  owners = [ "amazon" ]
  filter {
    name = "name"
    values = [var.imagename]
  } 
   filter {
     name = "virtualization-type"
     values = ["hvm"]    
   } 
}

resource "aws_key_pair" "my-key" {
  key_name = "new-key"
  public_key = file(var.key_pair)
}

resource "aws_instance" "my-amzon-server" {
  ami = data.aws_ami.latest-amazon-linux.id
  instance_type = var.inst_type

  subnet_id = var.subnet_id
  vpc_security_group_ids = [aws_security_group.my-sg.id]
  associate_public_ip_address = true
  key_name = aws_key_pair.my-key.key_name

  user_data = file("user-datafile.sh")



   tags = {
      Name = "${var.env_tag}-sg"
   }
}