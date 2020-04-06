locals {
  ingressAnnotations = {
    "kubernetes.io/ingress.class"                  = var.ingressName
    "nginx.ingress.kubernetes.io/backend-protocol" = var.backendProtocol
    "certmanager.k8s.io/cluster-issuer"            = var.clusterIssuer
    "nginx.ingress.kubernetes.io/proxy-body-size"  = var.proxyBodySize
  }
}

output "ingressAnnotations" {
  value = merge(var.additionalIngressAnnotations, local.ingressAnnotations)
}

