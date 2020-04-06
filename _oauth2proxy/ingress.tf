resource "kubernetes_ingress" "ingress" {
  count = var.ssoEnabled ? 1 : 0

  metadata {
    name        = module.data.namespaceUniqueName
    namespace   = local.namespace
    labels      = module.data.labels
    annotations = module.data.ingressAnnotations
  }

  spec {
    rule {
      host = var.host
      http {
        path {
          backend {
            service_name = kubernetes_service.service.0.metadata.0.name
            service_port = "http"
          }
          path = "/oauth2"
        }
      }
    }
    tls {
      hosts       = [var.host]
      secret_name = "${var.host}-tls"
    }
  }
}