locals {
  configVolume = {
    "provisioning.yml" = var.provisioningYml
    "datasources.yml" = var.datasourcesYml
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

resource "kubernetes_config_map" "configDashboards" {
  count = length(var.dashboards)
  metadata {
    name      = "${module.data.namespaceUniqueName}-dashboard-${keys(var.dashboards)[count.index]}"
    namespace = local.namespace
    labels    = module.data.labels
  }

  data = values(var.dashboards)[count.index]
}