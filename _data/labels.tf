locals {
  labels = {
    "app.kubernetes.io/name"       = var.name
    "app.kubernetes.io/instance"   = var.instance
    "app.kubernetes.io/version"    = var.versionLabel
    "app.kubernetes.io/component"  = var.component
    "app.kubernetes.io/part-of"    = var.partOf
    "app.kubernetes.io/managed-by" = "terraform"
  }
  matchLabels = {
    "app.kubernetes.io/name"     = var.name
    "app.kubernetes.io/instance" = var.instance
  }
  nodeSelectorLabels = {

  }
}

output "matchLabels" {
  value = local.matchLabels
}

output "labels" {
  value = local.labels
}

output "nodeSelector" {
  value = merge(var.additionalNodeSelectorLabels, local.nodeSelectorLabels)
}