provider "kubernetes" {
  version = "1.11.0"

}
terraform {
  backend "kubernetes" {
    load_config_file = true
    secret_suffix    = "ubuntu"
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

}

output "password" {
  value     = module.this.password
  sensitive = true
}