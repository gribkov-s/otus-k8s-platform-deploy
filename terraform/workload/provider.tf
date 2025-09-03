terraform {
  required_providers {
	helm = {
      source  = "hashicorp/helm"
      version = ">= 2.17"
    }
  }
}

provider "helm" {
  kubernetes = {
    config_path = "${path.module}/kubeconfig.yaml"
  }
}

provider "kubernetes" {
  config_path = "${path.module}/kubeconfig.yaml"
}