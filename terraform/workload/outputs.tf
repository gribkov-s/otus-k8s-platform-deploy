
output "otus_k8s_platform_deploy_app_microservices_demo_url" {
  value = "http://microservices-demo.${var.four_level_domain}.${yandex_vpc_address.otus_k8s_platform_deploy_ingress_ip.external_ipv4_address[0].address}.nip.io"
  description = "app microservices demo url"
}
