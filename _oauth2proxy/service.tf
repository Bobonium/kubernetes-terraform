resource "kubernetes_service" "service" {
  count = var.ssoEnabled ? 1 : 0

  metadata {
    name        = module.data.namespaceUniqueName
    namespace   = local.namespace
    labels      = module.data.labels
    annotations = module.data.serviceAnnotations
  }

  spec {
    type = "ClusterIP"
    port {
      name        = "http"
      port        = 80
      target_port = "http"
    }
    selector = module.data.labels
  }

}

output "servicePorts" {
  value = {
    http = 80
  }
}

output "serviceName" {
  value = var.ssoEnabled ? kubernetes_service.service.0.metadata.0.name : ""
}


