data "aws_ami" "centos" {
  owners = ["973714476881"]
  most_recent = true
  name_regex = "Centos-8-DevOps-Practice"
}
resource "aws_instance" "frontend" {
  ami           = data.aws_ami.centos.image_id
  instance_type = "t3.micro"

  tags = {
    Name = "frontend"
  }
}
resource "aws_route53_record" "frontend" {
  zone_id = "Z086778943HEZIHKI7U9"
  name = "frontend-dev.gehana26.online"
  type = "A"
  ttl = 30
  records = [aws_instance.frontend.private_ip]
}
#output "frontend" {
#  value = aws_instance.frontend.public_ip
#}

resource "aws_instance" "backend" {
  ami           = "data.aws_ami.centos.image_id"
  instance_type = "t3.micro"

  tags = {
    Name = "backend"
  }
}