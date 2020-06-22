locals {
  grafanaPlugins = []
  configEnv = {
    GF_INSTALL_PLUGINS = join(",", local.grafanaPlugins)
    GF_SERVER_ROOT_URL = "https://${var.host}"
    GF_DATABASE_TYPE = "postgres"
    GF_DATABASE_URL = "postgres://grafana:${random_string.dbPassword.result}@localhost:5432/grafana"
    GF_AUTH_ANONYMOUS_ORG_ROLE = "Admin"
    GF_AUTH_ANONYMOUS_ENABLED = "true"
    GF_METRICS_INTERVAL_SECONDS = "10"
    GF_PANELS_ENABLE_ALPHA = "true"
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