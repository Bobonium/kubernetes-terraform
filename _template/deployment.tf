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
          hash = sha1(base64encode(join("", concat(values(local.configVolume), values(local.configEnv), values(local.secretVolume), values(local.secretEnv)))))
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
          name = kubernetes_persistent_volume_claim.pvc.metadata.0.name
          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim.pvc.metadata.0.name
          }
        }
        volume {
          name = kubernetes_secret.secretVolume.metadata.0.name
          secret {
            secret_name = kubernetes_secret.secretVolume.metadata.0.name
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

          port {
            name           = "TODO"
            container_port = TODO
          }

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

          readiness_probe {
            initial_delay_seconds = 5
            success_threshold     = 1
            failure_threshold     = 1
            period_seconds        = 60
            timeout_seconds       = 3
            http_get {
              path = "/TODO"
              port = "TODO"
            }
          }

          liveness_probe {
            initial_delay_seconds = 300
            success_threshold     = 1
            failure_threshold     = 1
            period_seconds        = 300
            timeout_seconds       = 3
            http_get {
              path = "/TODO"
              port = "TODO"
            }
          }

          resources {
            requests {
              cpu    = "100m"
              memory = "128Mi"
            }
            limits {
              memory = "TODO"
            }
          }

          volume_mount {
            mount_path = "TODO"
            name       = kubernetes_persistent_volume_claim.pvc.metadata.0.name
          }

          volume_mount {
            mount_path = "TODO"
            name       = kubernetes_secret.secretVolume.metadata.0.name
          }

          volume_mount {
            mount_path = "TODO"
            name       = kubernetes_config_map.configVolume.metadata.0.name
          }
        }
      }
    }
  }
}
