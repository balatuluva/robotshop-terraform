#data "aws_ami" "centos" {
#  owners = ["973714476881"]
#  most_recent = true
#  name_regex = "Centos-8-DevOps-Practice"
#}
#data "aws_security_group" "allow-all" {
#  name = "allow-all"
#}
#variable "instance_type" {
#  default = "t3.small"
#}
#variable "components" {
#  default = [ "frontend", "mongodb", "catalogue" ]
#}
#variable "components" {}

resource "aws_instance" "instance" {
  for_each      = var.components
  ami           = data.aws_ami.centos.image_id
  instance_type = each.value["instance_type"]
  vpc_security_group_ids = [ data.aws_security_group.allow-all.id ]

  tags = {
    Name = each.value["name"]
  }
}

resource "null_resource" "provisioner" {
  depends_on = [aws_instance.instance, aws_route53_record.records]
  for_each = var.components
  provisioner "remote-exec" {
    connection {
      type = "ssh"
      user = "centos"
      password = "DevOps321"
      host = aws_instance.instance[each.value["name"]].private_ip
    }
    inline = [
      "rm -rf robotshop-shell",
      "git clone https://github.com/balatuluva/robotshop-shell.git"
      "cd robotshop-shell",
      "sudo bash ${each.value["name"]}.sh"
    ]
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

