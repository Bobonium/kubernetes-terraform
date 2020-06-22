provider "kubernetes" {
  version = "1.11.1"
}

terraform {
  backend "kubernetes" {
    load_config_file = true
    secret_suffix    = "grafana"
    namespace        = "tfstate-test"
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
  host                        = "grafana.${local.domain}"
  ingressName                 = local.ingressName
  ssoEnabled                  = local.ssoEnabled
  ssoClientId                 = local.ssoClientId
  ssoClientSecret             = local.ssoClientSecret
  ssoIssuerUrl                = local.ssoIssuerUrl
  ssoReplicas                 = 1
  unauthenticatedIngressPaths = local.unauthenticatedIngressPaths

  #variables.tf
  dashboards      = local.dashboards
  datasourcesYml  = local.datasourcesYml
  provisioningYml = local.provisioningYml
}
