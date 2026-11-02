output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnet_ids" {
  value = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  value = module.vpc.private_subnet_ids
}

output "web_public_ip" {
  description = "Open http://<this IP> in a browser to see nginx"
  value       = module.web.public_ip
}
