locals {
  configEnv = {
    TODO = "TODO"
  }
}

resource "kubernetes_config_map" "configEnv" {
  metadata {
    name      = "${module.data.namespaceUniqueName}-config-env"
    namespace = local.namespace
    labels    = module.data.labels
  }

  data = local.configEnv
}

output "configEnv" {
  value = {
    name = kubernetes_config_map.configEnv.metadata.0.name
    hash = sha1(join("", values(local.configEnv)))
  }
}