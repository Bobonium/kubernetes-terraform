module "this" {
  source = "../../"

  additionalIngressAnnotations = {
    additionalIngressAnnotations = "value"
  }
  additionalNamespaceAnnotations = {
    additionalNamespaceAnnotations = "value"
  }
  additionalPodAnnotations = {
    additionalPodAnnotations = "valse"
  }
  additionalServiceAnnotations = {
    additionalServiceAnnotations = "value"
  }
  backupVolumes        = ["backup1", "backup2"]
  backendProtocol      = "HTTP"
  clusterIssuer        = "clusterIssuer"
  clusterName          = "cluster.test"
  clusterNameDnsPrefix = "svc"
  component            = "component"
  externalDnsHostnames = ["host1", "host2"]
  ingressName          = "ingress"
  instance             = "instance"
  linkerdDisableHTTPS  = false
  linkerdEnabled       = true
  name                 = "name"
  namespace            = "namespace"
  partOf               = "partOf"
  prometheusPath       = "/metrics"
  proxyBodySize        = "10m"
  versionLabel         = "1.0.0"
  additionalNodeSelectorLabels = {
  }
}

output "clusterUniqueName" {
  value = module.this.clusterUniqueName
}

output "ingressAnnotations" {
  value = module.this.ingressAnnotations
}

output "labels" {
  value = module.this.labels
}

output "matchLabels" {
  value = module.this.matchLabels
}

output "namespaceAnnotations" {
  value = module.this.namespaceAnnotations
}

output "namespaceUniqueName" {
  value = module.this.namespaceUniqueName
}

output "podAnnotations" {
  value = module.this.podAnnotations
}

output "serviceAnnotations" {
  value = module.this.serviceAnnotations
}

