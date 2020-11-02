resource "aws_instance" "consul" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "m5.large"
  private_ip             = "10.0.2.100"
  subnet_id              = module.vpc.public_subnets[1]
  vpc_security_group_ids = [aws_security_group.consul.id]
  user_data              = file("../scripts/consul.sh")
  iam_instance_profile   = aws_iam_instance_profile.consul.name
  key_name               = aws_key_pair.demo.key_name
  tags = {
    Name  = "${var.prefix}consul"
    Env   = "consul"
    UK-SE = "arch"
  }
}

resource "aws_iam_role_policy" "consul" {
  name = "f5-consul-policy"
  role = aws_iam_role.consul.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ec2:DescribeInstances",
        "ec2:DescribeTags",
        "autoscaling:DescribeAutoScalingGroups"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role" "consul" {
  name = "f5-consul-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "consul" {
  name = "consul_sd"
  role = aws_iam_role.consul.name
}