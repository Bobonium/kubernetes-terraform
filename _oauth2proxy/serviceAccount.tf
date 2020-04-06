resource "kubernetes_service_account" "serviceAccount" {
  count = var.ssoEnabled ? 1 : 0

  metadata {
    name      = module.data.namespaceUniqueName
    namespace = local.namespace
    labels    = module.data.labels
  }

  automount_service_account_token = true
}

output "serviceAccountName" {
  value = var.ssoEnabled ? kubernetes_service_account.serviceAccount.0.metadata.0.name : ""
}