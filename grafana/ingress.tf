resource "kubernetes_ingress" "ingress" {
  metadata {
    name = module.data.namespaceUniqueName
    namespace = local.namespace
    labels = module.data.labels
    annotations = merge(module.data.ingressAnnotations, module.oauth2proxy.ingressAuthAnnotations)
  }

  spec {
    rule {
      host = var.host
      http {
        path {
          backend {
            service_name = kubernetes_service.service.metadata.0.name
            service_port = "http-metrics"
          }
          path = "/"
        }
      }
    }
    tls {
      hosts = [ var.host ]
      secret_name = "${var.host}-tls"
    }
  }
}

resource "kubernetes_ingress" "unauthenticatedIngress" {
  count = length(var.unauthenticatedIngressPaths) > 0 ? 1 : 0
  metadata {
    name = "${module.data.namespaceUniqueName}-no-sso"
    namespace = local.namespace
    labels = module.data.labels
    annotations = merge(module.data.ingressAnnotations)
  }

  spec {
    rule {
      host = var.host
      http {
        dynamic "path" {
          for_each = var.unauthenticatedIngressPaths
          content {
            backend {
              service_name = kubernetes_service.service.metadata.0.name
              service_port = "http-metrics"
            }
            path = path.value
          }
        }
      }
    }
    tls {
      hosts = [ var.host ]
      secret_name = "${var.host}-tls"
    }
  }
}

module "oauth2proxy" {
  source = "../_oauth2proxy"

  #varGeneral.tf
  instance = var.instance
  name = "${var.name}-oauth2-proxy"
  namespace = local.namespace
  replicas = var.ssoReplicas
  additionalNodeSelectorLabels = var.additionalNodeSelectorLabels
  clusterName = var.clusterName
  clusterNameDnsPrefix = var.clusterNameDnsPrefix
  partOf = var.name

  #varIngress.tf
  clusterIssuer = var.clusterIssuer
  host = var.host
  ingressName = var.ingressName
  ssoEnabled = var.ssoEnabled
  ssoClientId = var.ssoClientId
  ssoClientSecret = var.ssoClientSecret
  ssoIssuerUrl = var.ssoIssuerUrl
  deployNamespace = false
}