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

variable "deployNamespace" {}

variable "replicas" {}

variable "image" {
  default = "grafana/grafana:6.7.2"
}

variable "postgresImage" {
  default = "postgres:11.5"
}
