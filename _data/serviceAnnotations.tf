locals {
  serviceAnnotations = {
    "external-dns.alpha.kubernetes.io/hostname" = length(var.externalDnsHostnames) > 0 ? join(",", var.externalDnsHostnames) : null
  }
}

output "serviceAnnotations" {
  value = merge(var.additionalServiceAnnotations, local.serviceAnnotations)
}

