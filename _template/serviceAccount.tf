resource "kubernetes_service_account" "serviceAccount" {
  metadata {
    name      = module.data.namespaceUniqueName
    namespace = local.namespace
    labels    = module.data.labels
  }

  automount_service_account_token = true
}

output "serviceAccountName" {
  value = kubernetes_service_account.serviceAccount.metadata.0.name
}