output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer - use with /red or /blue"
  value       = module.alb.alb_dns_name
}

output "s3_bucket_name" {
  description = "S3 bucket name"
  value       = module.s3.bucket_name
}

output "red_instance_public_ip" {
  description = "Public IP of Red EC2 instance (for testing)"
  value       = module.ec2.red_public_ip
}

output "blue_instance_public_ip" {
  description = "Public IP of Blue EC2 instance (for testing)"
  value       = module.ec2.blue_public_ip
}

output "selected_subnet_ids" {
  description = "The two public subnets used for EC2 and ALB"
  value       = local.selected_subnet_ids
}

output "vpc_id" {
  value = data.aws_vpc.default.id
}