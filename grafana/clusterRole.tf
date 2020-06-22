resource "kubernetes_cluster_role_binding" "clusterRoleBinding" {
  metadata {
    name   = module.data.clusterUniqueName
    labels = module.data.labels
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.clusterRole.metadata.0.name
  }

  subject {
    kind      = "ServiceAccount"
    api_group = ""
    name      = kubernetes_service_account.serviceAccount.metadata.0.name
    namespace = local.namespace
  }
}

resource "kubernetes_cluster_role" "clusterRole" {
  metadata {
    name   = module.data.clusterUniqueName
    labels = module.data.labels
  }

  rule {
    api_groups = [""]
    resources = [""]
    verbs = [""]
  }

}
