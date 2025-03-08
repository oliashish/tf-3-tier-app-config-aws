# Output Instance id and  instance name
output "instance_id" {
  value = aws_instance.my_tf_instance.id
}

output "instance_name" {
  value = aws_instance.my_tf_instance.tags.Name
}

# Output Load balancer id and  Load balancer name
output "load_balancer_id" {
  value = aws_lb.my-tf-elb.id
}

output "load_balancer_name" {
  value = aws_lb.my-tf-elb.tags.Name
}

# Output dns name of the load balancer
output "dns_name" {
  value = aws_lb.my-tf-elb.dns_name
}

# output ssh key pair after instance is created to ssh into the instance
output "ssh_key_pair" {
  value = aws_instance.my_tf_instance.key_name
}
