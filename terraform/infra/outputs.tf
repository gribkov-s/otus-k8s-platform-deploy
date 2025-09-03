
output "otus_k8s_platform_deploy_agrocd_url" {
  value = "http://argocd.${var.four_level_domain}.${yandex_vpc_address.otus_k8s_platform_deploy_ingress_ip.external_ipv4_address[0].address}.nip.io"
  description = "agrocd url"
}

output "otus_k8s_platform_deploy_grafana_url" {
  value = "http://grafana.${var.four_level_domain}.${yandex_vpc_address.otus_k8s_platform_deploy_ingress_ip.external_ipv4_address[0].address}.nip.io"
  description = "grafana url"
}

output "otus_k8s_platform_deploy_prometheus_url" {
  value = "http://prometheus.${var.four_level_domain}.${yandex_vpc_address.otus_k8s_platform_deploy_ingress_ip.external_ipv4_address[0].address}.nip.io"
  description = "prometheus url"
}

output "otus_k8s_platform_deploy_alertmanager_url" {
  value = "http://alertmanager.${var.four_level_domain}.${yandex_vpc_address.otus_k8s_platform_deploy_ingress_ip.external_ipv4_address[0].address}.nip.io"
  description = "alertmanager url"
}
