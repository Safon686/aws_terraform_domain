output "vpc_id" {
    value = aws_vpc.main.id
}
output "vpc_cidr" {
    value = aws_vpc.main.cidr_block
}
output "aws_subnet1_id" {
    value = aws_subnet.my_subnet_az1.id
}
output "aws_subnet1_cidr" {
    value = aws_subnet.my_subnet_az1.cidr_block
}
output "aws_subnet2_id" {
    value = aws_subnet.my_subnet_az2.id
}
output "aws_subnet2_cidr" {
    value = aws_subnet.my_subnet_az2.cidr_block
}
output "security_group_for_instance_id" {
    value = aws_security_group.in_sec.id
}
output "security_group_web_my_sec" {
    value = aws_security_group.web_my_sec.id
}
output "launch_template_id" {
    value = aws_launch_template.web.id
}
output "ami" {
    value = aws_launch_template.web.image_id
}