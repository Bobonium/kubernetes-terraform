resource "kubernetes_cluster_role_binding" "clusterRoleBinding" {
  count = var.ssoEnabled ? 1 : 0

  metadata {
    name   = module.data.clusterUniqueName
    labels = module.data.labels
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.clusterRole.0.metadata.0.name
  }

  subject {
    kind      = "ServiceAccount"
    api_group = ""
    name      = kubernetes_service_account.serviceAccount.0.metadata.0.name
    namespace = local.namespace
  }
}

resource "kubernetes_cluster_role" "clusterRole" {
  count = var.ssoEnabled ? 1 : 0

  metadata {
    name   = module.data.clusterUniqueName
    labels = module.data.labels
  }

  rule {
    api_groups = [""]
    resources  = [""]
    verbs      = [""]
  }

}
