locals {
  secretVolumeVariables = {
    TODO = "TODO"
  }
  secretVolume = {
    TODO = templatefile("${path.module}/files/todo.secret.template.conf", local.secretVolumeVariables)
  }
}

resource "kubernetes_secret" "secretVolume" {
  metadata {
    name      = "${module.data.namespaceUniqueName}-secret-volume"
    namespace = local.namespace
    labels    = module.data.labels
  }

  data = local.secretVolume
}

output "secretVolume" {
  value = {
    name = kubernetes_secret.secretVolume.metadata.0.name
    hash = sha1(join("", values(local.secretVolume)))
  }
}