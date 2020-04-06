variable "additionalNodeSelectorLabels" {
  type = map(string)
}

variable "partOf" {
  description = "See: https://kubernetes.io/docs/concepts/overview/working-with-objects/common-labels/"
}

variable "clusterNameDnsPrefix" {
  description = "k8s internal dns names are in the scheme of <resourceName>.<namespace>.<clusterNameDnsPrefix>.<clusterName>"
}

variable "clusterName" {}

variable "instance" {}

variable "name" {}

variable "namespace" {}

variable "deployNamespace" {
  default = false
}

variable "replicas" {}

variable "image" {
  default = "ubuntu:18.04"
}
