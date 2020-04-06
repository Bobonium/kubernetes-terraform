locals {
  namespace = var.ssoEnabled && var.deployNamespace ? kubernetes_namespace.namespace[0].id : var.namespace
  version   = "1.0.0"
  component = "proxy"
}

module "data" {
  source = "../_data"


  additionalIngressAnnotations   = {}
  additionalNamespaceAnnotations = {}
  additionalNodeSelectorLabels   = var.additionalNodeSelectorLabels
  additionalPodAnnotations       = {}
  additionalServiceAnnotations   = {}
  backendProtocol                = "HTTP"
  backupVolumes = [
  ]
  clusterIssuer        = var.clusterIssuer
  clusterName          = var.clusterName
  clusterNameDnsPrefix = var.clusterNameDnsPrefix
  component            = local.component
  externalDnsHostnames = []
  ingressName          = var.ingressName
  instance             = var.instance
  linkerdDisableHTTPS  = true
  linkerdEnabled       = true
  name                 = var.name
  namespace            = local.namespace
  partOf               = var.partOf
  prometheusPath       = ""
  proxyBodySize        = "1m"
  versionLabel         = local.version
}

resource "kubernetes_namespace" "namespace" {
  count = var.ssoEnabled && var.deployNamespace ? 1 : 0
  metadata {
    name        = var.namespace
    labels      = module.data.labels
    annotations = module.data.namespaceAnnotations
  }
}

output "namespace" {
  value = local.namespace
}
