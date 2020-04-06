locals {
  annotations = {
    "nginx.ingress.kubernetes.io/auth-url"    = "http://${kubernetes_service.service.0.metadata.0.name}.${var.namespace}.${var.clusterNameDnsPrefix}.${var.clusterName}/oauth2/auth"
    "nginx.ingress.kubernetes.io/auth-signin" = "https://$host/oauth2/start?rd=$request_uri"
  }
}

output "ingressAuthAnnotations" {
  value = var.ssoEnabled ? local.annotations : {}
}