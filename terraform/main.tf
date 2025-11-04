terraform {
  required_providers {
    helm = {
      source = "hashicorp/helm"
      version = "2.12.1"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = ">= 2.0.0" 
    }

  }
}

provider "kubernetes" {
  # Configuration options
    config_path = "~/.kube/config"

}

provider "helm" {

  kubernetes {

    config_path = "~/.kube/config"
  }
}

