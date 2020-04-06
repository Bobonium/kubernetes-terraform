locals {
  #general
  name                 = "todo"
  namespace            = "todo"
  clusterName          = "cluster.todo"
  clusterNameDnsPrefix = "svc"
  instance             = "todo"
  domain               = "todo.todo"
  additionalNodeSelectorLabels = {
  }

  #sso
  ssoClientId     = local.name
  ssoClientSecret = "todo"
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
