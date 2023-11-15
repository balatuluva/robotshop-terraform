data "aws_ami" "centos" {
  owners = ["973714476881"]
  most_recent = true
  name_regex = "Centos-8-DevOps-Practice"
}
data "aws_security_group" "allow-all" {
  name = "allow-all"
}
#variable "instance_type" {
#  default = "t3.small"
#}
#variable "components" {
#  default = [ "frontend", "mongodb", "catalogue" ]
#}
variable "components" {
  default = {
    frontend = {
      name = "frontend"
      instance_type = "t3.small"
    }
    mongodb = {
      name = "mongodb"
      instance_type = "t3.small"
    }
    catalogue = {
      name = "catalogue"
      instance_type = "t3.micro"
    }
    redis = {
      name = "redis"
      instance_type = "t3.small"
    }
    user = {
      name = "user"
      instance_type = "t3.micro"
    }
    cart = {
      name = "cart"
      instance_type = "t3.micro"
    }
    mysql = {
      name = "mysql"
      instance_type = "t3.small"
    }
    shipping = {
      name = "shipping"
      instance_type = "t3.medium"
    }
    rabbitmq = {
      name = "rabbitmq"
      instance_type = "t3.small"
    }
    payment = {
      name = "payment"
      instance_type = "t3.small"
    }
    dispatch = {
      name = "dispatch"
      instance_type = "t3.small"
    }
  }
}
resource "aws_instance" "instance" {
  for_each      = var.components
  ami           = data.aws_ami.centos.image_id
  instance_type = each.value["instance_type"]
  vpc_security_group_ids = [ data.aws_security_group.allow-all.id ]

  tags = {
    Name = each.value["name"]
  }
}
resource "aws_route53_record" "records" {
  for_each = var.components
  zone_id = "Z086778943HEZIHKI7U9"
  name = "${each.value["name"]}-dev.gehana26.online"
  type = "A"
  ttl = 30
  records = [aws_instance.instance[each.value["name"]].private_ip]
}
#output "frontend" {
#  value = aws_instance.frontend.public_ip
#}

