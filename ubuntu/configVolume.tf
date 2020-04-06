locals {
  configVolumeVariables = {
    FOOBAR = "Hello World"
  }
  configVolume = {
    "test.conf" = templatefile("${path.module}/files/test.conf", local.configVolumeVariables)
  }
}

resource "kubernetes_config_map" "configVolume" {
  metadata {
    name      = "${module.data.namespaceUniqueName}-config-volume"
    namespace = local.namespace
    labels    = module.data.labels
  }

  data = local.configVolume
}

output "configVolume" {
  value = {
    name = kubernetes_config_map.configVolume.metadata.0.name
    hash = sha1(join("", values(local.configVolume)))
  }
}