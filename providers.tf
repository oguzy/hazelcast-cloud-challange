terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.10.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.5.1"
    }
    consul = {
      source  = "hashicorp/consul"
      version = "2.15.1"
    }
    vault = {
      source  = "hashicorp/vault"
      version = "3.5.0"
    }
  }
}


provider "kubernetes" {
  host = var.host

  client_certificate     = base64decode(var.client_certificate)
  client_key             = base64decode(var.client_key)
  cluster_ca_certificate = base64decode(var.cluster_ca_certificate)
}


provider "helm" {
  kubernetes {
    host = var.host

    client_certificate     = base64decode(var.client_certificate)
    client_key             = base64decode(var.client_key)
    cluster_ca_certificate = base64decode(var.cluster_ca_certificate)
  }
}

provider "vault" {
  address = "https://${val.fqdn}:8200"
  auth_login {
    path = "auth/userpass/login/${var.login_username}"

    parameters = {
      password = var.login_password
    }
  }
}
