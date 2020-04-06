variable "host" {}
variable "ingressName" {}
variable "clusterIssuer" {}
variable "ssoClientId" {}
variable "ssoClientSecret" {}
variable "ssoIssuerUrl" {}
variable "ssoReplicas" {}
variable "ssoEnabled" {}
variable "unauthenticatedIngressPaths" {
  type = "list"
}