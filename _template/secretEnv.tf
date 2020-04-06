locals {
  secretEnv = {
    TODO = "TODO"
  }
}

resource "kubernetes_secret" "secretEnv" {
  metadata {
    name      = "${module.data.namespaceUniqueName}-secret-env"
    namespace = local.namespace
    labels    = module.data.labels
  }

  data = local.secretEnv
}

output "secretEnv" {
  value = {
    name = kubernetes_secret.secretEnv.metadata.0.name
    hash = sha1(join("", values(local.secretEnv)))
  }
}