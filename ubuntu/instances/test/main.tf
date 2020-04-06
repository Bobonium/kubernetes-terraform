provider "kubernetes" {
  version = "1.11.0"

}

##requires https://github.com/hashicorp/terraform/pull/19525
#terraform {
#  backend "kubernetes" {
#    load_config_file = true
#    key              = "ubuntu"
#    namespace        = "terraform-test"
#  }
#}

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

}

output "password" {
  value     = module.this.password
  sensitive = true
}