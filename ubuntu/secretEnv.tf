resource "random_string" "password" {
  length = 128
}

locals {
  secretEnv = {
    PASSWORD = random_string.password.result
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

output "password" {
  value = random_string.password.result
}