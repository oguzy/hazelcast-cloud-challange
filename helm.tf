resource "kubernetes_namespace" "ingress" {
  metadata {
    annotations = {
      name = "ingress-nginx"
    }

    labels = {
      name = "ingress-nginx"
    }

    name = "ingress-nginx"
  }
}

resource "kubernetes_namespace" "consul" {
  metadata {
    annotations = {
      name = "consul"
    }

    labels = {
      name = "consul"
    }

    name = "consul"
  }
}

resource "kubernetes_namespace" "vault" {
  metadata {
    annotations = {
      name = "vault"
    }

    labels = {
      name = "vault"
    }

    name = "vault"
  }
}

resource "kubernetes_namespace" "monitoring" {
  metadata {
    annotations = {
      name = "monitoring"
    }

    labels = {
      name = "monitoring"
    }

    name = "monitoring"
  }
}

resource "helm_release" "ingress_nginx" {
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  name       = "ingress-nginx"
  namespace  = "ingress-nginx"

  values = [
    file("addons/ingress-nginx-values.yaml")
  ]
}

resource "helm_release" "consul" {
  repository = "https://helm.releases.hashicorp.com"
  chart      = "consul"
  name       = "consul"
  namespace  = "consul"

  values = [
    file("addons/consul-values.yaml")
  ]

  depends_on = [helm_release.ingress_nginx]
}

resource "helm_release" "vault" {
  repository = "https://helm.releases.hashicorp.com"
  chart      = "vault"
  name       = "vault"
  namespace  = "vault"

  values = [
    file("addons/vault-operator-values.yaml")
  ]

  depends_on = [helm_release.consul]
}

resource "helm_release" "prometheus_operator" {
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  name       = "prometheus-operator"
  namespace  = "monitoring"

  values = [
    file("addons/prometheus-operator-values.yaml")
  ]

  set {
    name  = "alertmanager.alertmanagerSpec.externalUrl"
    value = "http://${var.fqdn}/alertmanager"
  }

  set {
    name  = "prometheus.prometheusSpec.externalUrl"
    value = "http://${var.fqdn}/prometheus"
  }

  #set {
  #  name  = "controller.admissionWebhooks.enabled"
  #  value = "false"
  #}


  depends_on = [helm_release.vault]
}
