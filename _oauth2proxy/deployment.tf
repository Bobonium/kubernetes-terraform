resource "kubernetes_deployment" "deployment" {
  count = var.ssoEnabled ? 1 : 0

  metadata {
    name      = module.data.namespaceUniqueName
    namespace = local.namespace
    labels    = module.data.labels
  }

  spec {
    replicas = var.replicas

    selector {
      match_labels = module.data.matchLabels
    }

    min_ready_seconds = 10

    template {
      metadata {
        labels = merge(module.data.labels, {
          hash = sha1(base64encode(join("", concat(values(local.secretEnv)))))
        })
        annotations = module.data.podAnnotations
      }

      spec {
        service_account_name             = kubernetes_service_account.serviceAccount.0.metadata.0.name
        automount_service_account_token  = true
        host_network                     = false
        termination_grace_period_seconds = 60
        dns_policy                       = "ClusterFirst"

        node_selector = module.data.nodeSelector
        affinity {
          pod_anti_affinity {
            preferred_during_scheduling_ignored_during_execution {
              weight = 100
              pod_affinity_term {
                topology_key = "kubernetes.io/hostname"
                label_selector {
                  match_labels = module.data.matchLabels
                }
              }
            }
          }
        }

        container {
          name  = var.name
          image = var.image

          args = [
            "--provider=oidc",
            "--upstream=file://dev/null",
            "--set-xauthrequest",
            "--http-address=0.0.0.0:4180",
            "--skip-provider-button",
            "--email-domain=*",
            "--ssl-insecure-skip-verify",
            "--silence-ping-logging=true",
            "--oidc-issuer-url=${var.ssoIssuerUrl}",
          ]

          security_context {
            read_only_root_filesystem  = true
            allow_privilege_escalation = false
            privileged                 = false
            run_as_user                = 0
            run_as_group               = 0
            capabilities {
              drop = ["ALL"]
            }
          }


          port {
            name           = "http"
            container_port = 4180
          }

          env_from {
            secret_ref {
              name = kubernetes_secret.secretEnv.0.metadata.0.name
            }
          }

          readiness_probe {
            initial_delay_seconds = 3
            success_threshold     = 1
            failure_threshold     = 1
            period_seconds        = 30
            timeout_seconds       = 3
            http_get {
              path = "/ping"
              port = "http"
            }
          }

          liveness_probe {
            initial_delay_seconds = 300
            success_threshold     = 1
            failure_threshold     = 1
            period_seconds        = 300
            timeout_seconds       = 3
            http_get {
              path = "/ping"
              port = "http"
            }
          }

          resources {
            requests {
              cpu    = "10m"
              memory = "16Mi"
            }
            limits {
              memory = "128Mi"
            }
          }

        }
      }
    }
  }
}
