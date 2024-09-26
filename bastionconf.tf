provisioner "file" {
  source      = "ansible_playbook.yml"
  destination = "/tmp/ansible_playbook.yml"
  connection {
    type     = "ssh"
    user     = "ec2-user"
    private_key = file("~/.ssh/your-key.pem")
    host     = aws_instance.bastion.public_ip
  }
}

provisioner "remote-exec" {
  inline = [
    "sudo yum install -y ansible",
    "ansible-playbook /tmp/ansible_playbook.yml -i /tmp/inventory.ini"
  ]
  connection {
    type     = "ssh"
    user     = "ec2-user"
    private_key = file("~/.ssh/your-key.pem")
    host     = aws_instance.bastion.public_ip
  }
}
