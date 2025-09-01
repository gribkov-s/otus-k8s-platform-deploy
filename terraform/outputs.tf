output "otus_k8s_platform_deploy_cluster_endpoint" {
  value = yandex_kubernetes_cluster.otus_k8s_platform_deploy_cluster.master[0].external_v4_endpoint
  description = "cluster endpoint"
}

output "otus_k8s_platform_deploy_cluster_id" {
  value = yandex_kubernetes_cluster.otus_k8s_platform_deploy_cluster.id
  description = "cluster id"
}

output "otus_k8s_platform_deploy_agrocd_url" {
  value = "http://argocd.${variable.four_level_domain}.${yandex_vpc_address.otus_k8s_platform_deploy_ingress_ip.external_ipv4_address[0].address}.nip.io"
  description = "agrocd url"
}

output "otus_k8s_platform_deploy_grafana_url" {
  value = "http://grafana.${variable.four_level_domain}.${yandex_vpc_address.otus_k8s_platform_deploy_ingress_ip.external_ipv4_address[0].address}.nip.io"
  description = "grafana url"
}

output "otus_k8s_platform_deploy_prometheus_url" {
  value = "http://prometheus.${variable.four_level_domain}.${yandex_vpc_address.otus_k8s_platform_deploy_ingress_ip.external_ipv4_address[0].address}.nip.io"
  description = "prometheus url"
}

output "otus_k8s_platform_deploy_alertmanager_url" {
  value = "http://alertmanager.${variable.four_level_domain}.${yandex_vpc_address.otus_k8s_platform_deploy_ingress_ip.external_ipv4_address[0].address}.nip.io"
  description = "alertmanager url"
}

output "otus_k8s_platform_deploy_app_microservices_demo_url" {
  value = "http://microservices-demo.${variable.four_level_domain}.${yandex_vpc_address.otus_k8s_platform_deploy_ingress_ip.external_ipv4_address[0].address}.nip.io"
  description = "app microservices demo url"
}
