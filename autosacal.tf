resource "aws_launch_template" "app_template" {
  name_prefix   = "app_template_"
  image_id      = "ami-0e86e20dae9224db8"  
  instance_type = "t2.micro"

  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [aws_security_group.bastion_sg.id]
  }
}

resource "aws_autoscaling_group" "app_asg" {
  vpc_zone_identifier = [aws_subnet.private_subnet_a.id]
  launch_template {
    id      = aws_launch_template.app_template.id
    version = "$Latest"
  }
  min_size     = 2
  max_size     = 2
  desired_capacity = 2
}

resource "aws_lb" "app_lb" {
  name               = "app_lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.bastion_sg.id]
  subnets            = [aws_subnet.public_subnet_a.id]

  enable_deletion_protection = false
  enable_cross_zone_load_balancing = true
}

output "private_instance_ips" {
  value = aws_autoscaling_group.app_asg.instances
}
