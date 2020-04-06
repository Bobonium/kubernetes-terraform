resource "kubernetes_deployment" "deployment" {

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

    min_ready_seconds = 0

    template {
      metadata {
        labels = merge(module.data.labels, {
          hash = sha1(base64encode(join("", concat(values(local.configVolume), values(local.configEnv), values(local.secretEnv)))))
        })
        annotations = module.data.podAnnotations
      }

      spec {
        service_account_name             = kubernetes_service_account.serviceAccount.metadata.0.name
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

        volume {
          name = kubernetes_config_map.configVolume.metadata.0.name
          config_map {
            name = kubernetes_config_map.configVolume.metadata.0.name
          }
        }

        container {
          name  = var.name
          image = var.image

          tty     = true
          command = ["cat"]

          env_from {
            secret_ref {
              name = kubernetes_secret.secretEnv.metadata.0.name
            }
          }

          env_from {
            config_map_ref {
              name = kubernetes_config_map.configEnv.metadata.0.name
            }
          }

          resources {
            requests {
              cpu    = "100m"
              memory = "128Mi"
            }
            limits {
              memory = "1024Mi"
            }
          }

          volume_mount {
            mount_path = "/config"
            name       = kubernetes_config_map.configVolume.metadata.0.name
          }
        }
      }
    }
  }
}
