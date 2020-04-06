provider "kubernetes" {
  version = "1.11.0"

}

terraform {
  backend "kubernetes" {
    load_config_file = true
    key              = "TODO"
    namespace        = "terraform-TODO"
  }
}

module "this" {
  source = "../../"

  #varGeneral.tf
  partOf                       = "cluster"
  clusterName                  = local.clusterName
  clusterNameDnsPrefix         = local.clusterNameDnsPrefix
  instance                     = local.instance
  name                         = local.name
  namespace                    = local.namespace
  deployNamespace              = false
  replicas                     = 1
  additionalNodeSelectorLabels = local.additionalNodeSelectorLabels

  #varIngress.tf
  clusterIssuer               = local.clusterIssuer
  host                        = "TODO.${local.domain}"
  ingressName                 = local.ingressName
  ssoEnabled                  = local.ssoEnabled
  ssoClientId                 = local.ssoClientId
  ssoClientSecret             = local.ssoClientSecret
  ssoIssuerUrl                = local.ssoIssuerUrl
  ssoReplicas                 = 1
  unauthenticatedIngressPaths = local.unauthenticatedIngressPaths


  #varStorage.tf
  storageClassName = local.storageClassName
  storageSize      = "10Gi"
}
