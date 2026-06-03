output "cluster_id" {
  description = "Nebius Kubernetes Cluster ID"
  value       = nebius_mk8s_v1_cluster.vllm_lab.id
}

output "cluster_name" {
  description = "Nebius Kubernetes Cluster Name"
  value       = nebius_mk8s_v1_cluster.vllm_lab.name
}