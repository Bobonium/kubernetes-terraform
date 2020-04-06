resource "kubernetes_ingress" "ingress" {
  metadata {
    name        = module.data.namespaceUniqueName
    namespace   = local.namespace
    labels      = module.data.labels
    annotations = merge(module.data.ingressAnnotations, module.oauth2proxy.ingressAuthAnnotations)
  }

  spec {
    rule {
      host = var.host
      http {
        path {
          backend {
            service_name = kubernetes_service.service.metadata.0.name
            service_port = "TODO"
          }
          path = "/"
        }
      }
    }
    tls {
      hosts       = [var.host]
      secret_name = "${var.host}-tls"
    }
  }
}

resource "kubernetes_ingress" "unauthenticatedIngress" {
  count = length(var.unauthenticatedIngressPaths) > 0 ? 1 : 0
  metadata {
    name        = "${module.data.namespaceUniqueName}-no-sso"
    namespace   = local.namespace
    labels      = module.data.labels
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
              service_port = "TODO"
            }
            path = path.value
          }
        }
      }
    }
    tls {
      hosts       = [var.host]
      secret_name = "${var.host}-tls"
    }
  }
}

module "oauth2proxy" {
  source = "../_oauth2proxy"

  clusterIssuer                = var.clusterIssuer
  clusterName                  = var.clusterName
  clusterNameDnsPrefix         = var.clusterNameDnsPrefix
  ssoClientId                  = var.ssoClientId
  ssoClientSecret              = var.ssoClientSecret
  ssoIssuerUrl                 = var.ssoIssuerUrl
  host                         = var.host
  ingressName                  = var.ingressName
  instance                     = var.instance
  name                         = "${var.name}-oauth2-proxy"
  namespace                    = local.namespace
  partOf                       = var.name
  replicas                     = var.ssoReplicas
  additionalNodeSelectorLabels = var.additionalNodeSelectorLabels
  ssoEnabled                   = var.ssoEnabled
}