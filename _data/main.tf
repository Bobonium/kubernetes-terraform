output "clusterUniqueName" {
  value = var.instance != "" ? "${var.instance}-${var.name}-${var.namespace}" : "${var.name}-${var.namespace}"
}

output "namespaceUniqueName" {
  value = var.instance != "" ? "${var.instance}-${var.name}" : var.name
}
