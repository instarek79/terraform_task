resource "aws_instance" "bastion" {
  ami           = "ami-0e86e20dae9224db8"  
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public_subnet_a.id
  key_name      = #keypairs

  security_groups = [aws_security_group.bastion_sg.id]
}
