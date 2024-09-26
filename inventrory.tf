resource "local_file" "inventory" {
  content = templatefile("${path.module}/inventory.tpl", {
    private_ips = aws_autoscaling_group.app_asg.instances
  })
  filename = "${path.module}/inventory.ini"
}
