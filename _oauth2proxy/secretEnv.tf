resource "random_string" "cookieSecret" {
  count  = var.ssoEnabled ? 1 : 0
  length = 128
}

locals {
  secretEnv = {
    OAUTH2_PROXY_CLIENT_ID     = var.ssoClientId
    OAUTH2_PROXY_CLIENT_SECRET = var.ssoClientSecret
    OAUTH2_PROXY_COOKIE_SECRET = base64encode(random_string.cookieSecret.0.result)
  }
}

resource "kubernetes_secret" "secretEnv" {
  count = var.ssoEnabled ? 1 : 0

  metadata {
    name      = "${module.data.namespaceUniqueName}-secret-env"
    namespace = local.namespace
    labels    = module.data.labels
  }

  data = local.secretEnv
}

output "secretEnv" {
  value = {
    name = var.ssoEnabled ? kubernetes_secret.secretEnv.0.metadata.0.name : ""
    hash = sha1(join("", values(local.secretEnv)))
  }
}