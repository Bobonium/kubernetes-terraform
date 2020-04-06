locals {
  namespaceAnnotations = {
  }
}

output "namespaceAnnotations" {
  value = merge(var.additionalNamespaceAnnotations, local.namespaceAnnotations)
}

