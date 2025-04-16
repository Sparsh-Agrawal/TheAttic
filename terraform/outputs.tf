output "cluster_name" {
  value = module.eks.cluster_name
}

output "eks_endpoint" {
  value = module.eks.cluster_endpoint
}

output "load_balancer_hostname" {
  value       = try(data.kubernetes_service.simple_time_service.status[0].load_balancer[0].ingress[0].hostname, "")
  description = "Public Load Balancer Endpoint"
}