data "aws_ami" "f5_ami" {
  most_recent = true
  owners      = ["679593333241"]

  filter {
    name   = "name"
    values = [var.f5_ami_search_name]
  }
}

resource "aws_network_interface" "mgmt" {
  subnet_id       = module.vpc.public_subnets[0]
  private_ips     = ["10.0.1.10"]
  security_groups = [aws_security_group.mgmt.id]
}

resource "aws_network_interface" "public" {
  subnet_id       = module.vpc.public_subnets[1]
  private_ips     = ["10.0.2.10", "10.0.2.101"]
  security_groups = [aws_security_group.public.id]
}

resource "aws_network_interface" "private" {
  subnet_id   = module.vpc.private_subnets[0]
  private_ips = ["10.0.3.10"]
}

resource "aws_eip" "mgmt" {
  vpc                       = true
  network_interface         = aws_network_interface.mgmt.id
  associate_with_private_ip = "10.0.1.10"
}

resource "aws_eip" "public-self" {
  vpc                       = true
  network_interface         = aws_network_interface.public.id
  associate_with_private_ip = "10.0.2.10"
}

resource "aws_eip" "public-vs1" {
  vpc                       = true
  network_interface         = aws_network_interface.public.id
  associate_with_private_ip = "10.0.2.101"
}

data "template_file" "f5_init" {
  template = file("../scripts/f5_onboard.tmpl")

  vars = {
    password  = random_string.password.result
    doVersion = "latest"
    #example version:
    #as3Version           = "3.16.0"
    as3Version  = "latest"
    tsVersion   = "latest"
    cfVersion   = "latest"
    fastVersion = "latest"
    onboard_log = "/var/log/onboard.log"
  }
}

resource "aws_instance" "f5" {

  ami       = data.aws_ami.f5_ami.id
  user_data = data.template_file.f5_init.rendered

  instance_type = "t2.medium"
  key_name      = aws_key_pair.demo.key_name
  root_block_device { delete_on_termination = true }

  network_interface {
    network_interface_id = aws_network_interface.mgmt.id
    device_index         = 0
  }

  network_interface {
    network_interface_id = aws_network_interface.public.id
    device_index         = 1
  }

  network_interface {
    network_interface_id = aws_network_interface.private.id
    device_index         = 2
  }

  provisioner "local-exec" {
    command = "while [[ \"$(curl -skiu admin:${random_string.password.result} https://${self.public_ip}/mgmt/shared/appsvcs/declare | grep -Eoh \"^HTTP/1.1 204\")\" != \"HTTP/1.1 204\" ]]; do sleep 5; done"
  }

  tags = {
    Name  = "${var.prefix}f5-1"
    Env   = "consul"
    UK-SE = "arch"
  }
}