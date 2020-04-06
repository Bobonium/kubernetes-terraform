variable "name" {}

variable "namespace" {}

variable "instance" {}

variable "clusterName" {}

variable "clusterNameDnsPrefix" {
  description = "k8s internal dns names are in the scheme of <resourceName>.<namespace>.<clusterNameDnsPrefix>.<clusterName>"
}

variable "versionLabel" {}

variable "component" {}

variable "partOf" {
  description = "See: https://kubernetes.io/docs/concepts/overview/working-with-objects/common-labels/"
}

variable "additionalPodAnnotations" {
  type = map(string)
}

variable "additionalServiceAnnotations" {
  type = map(string)
}

variable "additionalIngressAnnotations" {
  type = map(string)
}

variable "additionalNodeSelectorLabels" {
  type = map(string)
}

variable "additionalNamespaceAnnotations" {
  type = map(string)
}

variable "prometheusPath" {}

variable "ingressName" {}

variable "externalDnsHostnames" {
  type = list(string)
}

variable "backendProtocol" {}

variable "clusterIssuer" {}

variable "proxyBodySize" {}

variable "linkerdEnabled" {}

variable "linkerdDisableHTTPS" {}

variable "backupVolumes" {
  type = list(string)
}
