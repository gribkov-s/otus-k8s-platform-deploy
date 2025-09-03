output "otus_k8s_platform_deploy_cluster_endpoint" {
  value = yandex_kubernetes_cluster.otus_k8s_platform_deploy_cluster.master[0].external_v4_endpoint
  description = "cluster endpoint"
}

output "otus_k8s_platform_deploy_cluster_id" {
  value = yandex_kubernetes_cluster.otus_k8s_platform_deploy_cluster.id
  description = "cluster id"
}
