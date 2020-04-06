locals {
  #general
  name                 = "ubuntu"
  namespace            = "default"
  clusterName          = "cluster.name"
  clusterNameDnsPrefix = "svc"
  instance             = "test"
  domain               = "example.org"
  additionalNodeSelectorLabels = {
  }

  #sso
  ssoClientId     = local.name
  ssoClientSecret = "none"
  ssoIssuerUrl    = "https://auth.${local.domain}"
  ssoEnabled      = false

  #ingress
  ingressName   = "${local.instance}-ingress-nginx-traffic"
  clusterIssuer = "${local.instance}-self-signed"
  #clusterIssuer = "${local.instance}-letsencrypt-prod"
  unauthenticatedIngressPaths = []

  #storage
  storageClassName = "${local.instance}-openebs-storage-hostpath"
  #storageClassName = "${local.instance}-nfs-client-provisioner-storage"

}
