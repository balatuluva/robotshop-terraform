data "aws_ami" "centos" {
  owners = ["973714476881"]
  most_recent = true
  name_regex = "Centos-8-DevOps-Practice"
}
data "aws_security_group" "allow-all" {
  name = "allow-all"
}
variable "instance_type" {
  default = "t3.small"
}
variable "components" {
  default = [ "frontend", "mongodb", "catalogue" ]
}
resource "aws_instance" "instance" {
  count         = length(var.components)
  ami           = data.aws_ami.centos.image_id
  instance_type = var.instance_type
  vpc_security_group_ids = [ data.aws_security_group.allow-all.id ]

  tags = {
    Name = var.components[count.index]
  }
}
#resource "aws_route53_record" "frontend" {
#  zone_id = "Z086778943HEZIHKI7U9"
#  name = "frontend-dev.gehana26.online"
#  type = "A"
#  ttl = 30
#  records = [aws_instance.frontend.private_ip]
#}
#output "frontend" {
#  value = aws_instance.frontend.public_ip
#}

