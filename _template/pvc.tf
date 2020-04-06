resource "kubernetes_persistent_volume_claim" "pvc" {
  metadata {
    name      = module.data.namespaceUniqueName
    namespace = local.namespace
    labels    = module.data.labels
  }


  spec {
    storage_class_name = var.storageClassName
    access_modes       = var.storageAccessModes
    resources {
      requests = {
        storage = var.storageSize
      }
    }
  }
  wait_until_bound = false
}
