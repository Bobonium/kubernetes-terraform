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
      name        = "TODO"
      port        = TODO
      target_port = "TODO"
    }
    selector = module.data.labels
  }

}

output "servicePorts" {
  value = {
    TODO = "TODO"
  }
}

output "serviceName" {
  value = kubernetes_service.service.metadata.0.name
}


