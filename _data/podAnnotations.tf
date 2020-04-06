locals {
  podAnnotations = {
    "prometheus.io/scrape"               = var.prometheusPath != "" ? "true" : null
    "prometheus.io/path"                 = var.prometheusPath != "" ? var.prometheusPath : null
    "linkerd.io/inject"                  = var.linkerdEnabled ? "enabled" : null
    "config.linkerd.io/disable-identity" = var.linkerdEnabled ? var.linkerdDisableHTTPS ? null : "true" : false
    "backup.velero.io/backup-volumes"    = length(var.backupVolumes) > 0 ? join(",", var.backupVolumes) : null
  }
}

output "podAnnotations" {
  value = merge(var.additionalPodAnnotations, local.podAnnotations)
}

