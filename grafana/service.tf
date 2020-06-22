resource "kubernetes_service" "service" {
  metadata {
    name        = module.data.namespaceUniqueName
    namespace   = local.namespace
    labels      = module.data.labels
    annotations = module.data.serviceAnnotations
  }

  spec {
    type = "ClusterIP"
    port {
      name        = "http-metrics"
      port        = 80
      target_port = "http-metrics"
    }
    selector = module.data.labels
  }

}

output "servicePorts" {
  value = {
    http-metrics = "80"
  }
}

output "serviceName" {
  value = kubernetes_service.service.metadata.0.name
}


