
# 1. Ingress контроллер
resource "helm_release" "otus_k8s_platform_deploy_ingress_nginx" {
  name = "otus-k8s-platform-deploy-ingress-nginx"
  namespace = "ingress-nginx"
  repository = "oci://registry-1.docker.io/bitnamicharts"    
  chart = "nginx-ingress-controller"
  
  atomic = true
  create_namespace = true
  values = [templatefile("./helm/ingress-values.yaml", {
    ingress_ip = yandex_vpc_address.otus_k8s_platform_deploy_ingress_ip.external_ipv4_address[0].address
  })]
  
  depends_on = [
    yandex_kubernetes_node_group.otus_k8s_platform_deploy_infra_node_group,
	yandex_vpc_address.otus_k8s_platform_deploy_ingress_ip,
	null_resource.generate_kubeconfig
  ]
}

# 2. ArgoCD

# 2.1 ArgoCD release
resource "helm_release" "otus_k8s_platform_deploy_argo_cd" {
  name = "otus-k8s-platform-deploy-argo-cd"
  namespace = "argo-cd"
  repository = "https://argoproj.github.io/argo-helm"    
  chart = "argo-cd"
  
  atomic = true
  create_namespace = true
  values = [file("./helm/argocd-values.yaml")]
  
  depends_on = [
    yandex_kubernetes_node_group.otus_k8s_platform_deploy_infra_node_group,
	null_resource.generate_kubeconfig
  ]
}

# 2.2 ArgoCD ingress
resource "kubernetes_ingress_v1" "otus_k8s_platform_deploy_argo_cd_ingress" {
  metadata {
    name = "otus-k8s-platform-deploy-argo-cd-ingress"
	namespace = "argo-cd"
  }
  
  depends_on = [
    helm_release.otus_k8s_platform_deploy_ingress_nginx,
    helm_release.otus_k8s_platform_deploy_argo_cd
  ]

  spec {
    ingress_class_name = "nginx"
    rule {
      host = "argocd.${var.four_level_domain}.${yandex_vpc_address.otus_k8s_platform_deploy_ingress_ip.external_ipv4_address[0].address}.nip.io"
      http {
        path {
          path = "/"
          path_type = "Prefix"
          backend {
            service {
              name = "otus-k8s-platform-deploy-argo-cd-argocd-server"
              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }
}

# 3. Логирование

# 3.1 Loki
resource "helm_release" "otus_k8s_platform_deploy_loki" {
  name = "otus-k8s-platform-deploy-loki"
  namespace = "loki"
  repository = "https://grafana.github.io/helm-charts"
  chart = "loki"

  atomic = true
  create_namespace = true
  
  values = [templatefile("./helm/loki-values.yaml", {
    bucket_name = yandex_storage_bucket.otus_k8s_deploy_platform_logs_storage.bucket
	access_key_id = yandex_iam_service_account_static_access_key.otus_k8s_platform_deploy_logs_storage_sa_access.access_key
	secret_access_key = yandex_iam_service_account_static_access_key.otus_k8s_platform_deploy_logs_storage_sa_access.secret_key
  })]
  
  depends_on = [
    yandex_kubernetes_node_group.otus_k8s_platform_deploy_infra_node_group,
	yandex_storage_bucket.otus_k8s_platform_deploy_logs_storage,
	null_resource.generate_kubeconfig
  ]
}

# 3.2 Promtail
resource "helm_release" "otus_k8s_platform_deploy_promtail" {
  name = "otus-k8s-platform-deploy-promtail"
  namespace = "promtail"
  repository = "https://grafana.github.io/helm-charts"
  chart = "promtail"

  atomic = true
  create_namespace = true
  values = [file("./helm/promtail-values.yaml")]

  depends_on = [
    yandex_kubernetes_node_group.otus_k8s_platform_deploy_infra_node_group,
	null_resource.generate_kubeconfig
  ]
}

# 4. Мониторинг

# 4.1 Prometheus stack
resource "helm_release" "otus_k8s_platform_deploy_kube_prometheus_stack" {
  name = "otus-k8s-platform-deploy-kube-prometheus-stack"
  namespace = "kube-prometheus-stack"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart = "kube-prometheus-stack"

  atomic = true
  create_namespace = true
  values = [file("./helm/kube-prometheus-stack-values.yaml")]

  depends_on = [
	yandex_kubernetes_node_group.otus_k8s_platform_deploy_infra_node_group,
	null_resource.generate_kubeconfig
  ]
}

# 4.2 Grafana ingress
resource "kubernetes_ingress_v1" "otus_k8s_platform_deploy_grafana_ingress" {
  metadata {
    name = "otus-k8s-platform-deploy-grafana-ingress"
	namespace = "kube-prometheus-stack"
  }
  
  depends_on = [
    helm_release.otus_k8s_platform_deploy_ingress_nginx,
    helm_release.otus_k8s_platform_deploy_kube_prometheus_stack
  ]

  spec {
    ingress_class_name = "nginx"
    rule {
      host = "grafana.${var.four_level_domain}.${yandex_vpc_address.otus_k8s_platform_deploy_ingress_ip.external_ipv4_address[0].address}.nip.io"
      http {
        path {
          path = "/"
          path_type = "Prefix"
          backend {
            service {
              name = "otus-k8s-platform-deploy-kube-prometheus-stack-grafana"
              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }
}

# 4.3 Prometheus ingress
resource "kubernetes_ingress_v1" "otus_k8s_platform_deploy_prometheus_ingress" {
  metadata {
    name = "otus-k8s-platform-deploy-prometheus-ingress"
	namespace = "kube-prometheus-stack"
  }
  
  depends_on = [
    helm_release.otus_k8s_platform_deploy_ingress_nginx,
    helm_release.otus_k8s_platform_deploy_kube_prometheus_stack
  ]

  spec {
    ingress_class_name = "nginx"
    rule {
      host = "prometheus.${var.four_level_domain}.${yandex_vpc_address.otus_k8s_platform_deploy_ingress_ip.external_ipv4_address[0].address}.nip.io"
      http {
        path {
          path = "/"
          path_type = "Prefix"
          backend {
            service {
              name = "otus-k8s-platform-deploy-kube-pro-prometheus"
              port {
                number = 9090
              }
            }
          }
        }
      }
    }
  }
}

# 4.3 Alert manager ingress
resource "kubernetes_ingress_v1" "otus_k8s_platform_deploy_alertmanager_ingress" {
  metadata {
    name = "otus-k8s-platform-deploy-alertmanager-ingress"
	namespace = "kube-prometheus-stack"
  }
  
  depends_on = [
    helm_release.otus_k8s_platform_deploy_ingress_nginx,
    helm_release.otus_k8s_platform_deploy_kube_prometheus_stack
  ]

  spec {
    ingress_class_name = "nginx"
    rule {
      host = "alertmanager.${var.four_level_domain}.${yandex_vpc_address.otus_k8s_platform_deploy_ingress_ip.external_ipv4_address[0].address}.nip.io"
      http {
        path {
          path = "/"
          path_type = "Prefix"
          backend {
            service {
              name = "otus-k8s-platform-deploy-kube-pro-alertmanager"
              port {
                number = 9093
              }
            }
          }
        }
      }
    }
  }
}