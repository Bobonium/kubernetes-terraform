resource "kubernetes_deployment" "deployment" {

  metadata {
    name      = module.data.namespaceUniqueName
    namespace = local.namespace
    labels = module.data.labels
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
          hash = sha1(base64encode(join("", concat(values(local.configVolume), values(local.configEnv)))))
        })
        annotations = module.data.podAnnotations
      }

      spec {
        service_account_name = kubernetes_service_account.serviceAccount.metadata.0.name
        automount_service_account_token = true
        host_network = false
        termination_grace_period_seconds = 60
        dns_policy = "ClusterFirst"

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
        dynamic "volume" {
          for_each = var.dashboards
          content {
            name = "${module.data.namespaceUniqueName}-dashboard-${replace(volume.key, "/.*\\//", "")}"
            config_map {
              name = "${module.data.namespaceUniqueName}-dashboard-${replace(volume.key, "/.*\\//", "")}"
            }
          }
        }

        container {
          name  = var.name
          image = var.image

          security_context {
            read_only_root_filesystem = null
            allow_privilege_escalation = false
            privileged = false
            run_as_user = 0
            run_as_group = 0
          }

          port {
            name           = "http-metrics"
            container_port = 3000
          }

          env_from {
            config_map_ref {
              name = kubernetes_config_map.configEnv.metadata.0.name
            }
          }

          readiness_probe {
            initial_delay_seconds = 5
            success_threshold = 1
            failure_threshold = 1
            period_seconds = 60
            timeout_seconds = 3
            http_get {
              path = "/api/health"
              port = "http-metrics"
            }
          }

          liveness_probe {
            initial_delay_seconds = 300
            success_threshold = 1
            failure_threshold = 1
            period_seconds = 300
            timeout_seconds = 3
            http_get {
              path = "/api/health"
              port = "http-metrics"
            }
          }

          resources {
            requests {
              cpu    = "25m"
              memory = "128Mi"
            }
            limits {
              memory = "512Mi"
            }
          }

          volume_mount {
            mount_path = "/etc/grafana/provisioning/dashboards/provisioning.yml"
            sub_path = "provisioning.yml"
            name = kubernetes_config_map.configVolume.metadata.0.name
          }
          volume_mount {
            mount_path = "/etc/grafana/provisioning/datasources/datasources.yml"
            sub_path = "datasources.yml"
            name = kubernetes_config_map.configVolume.metadata.0.name
          }
          dynamic "volume_mount" {
            for_each = var.dashboards
            content {
              mount_path = "/var/lib/grafana/dashboards/${volume_mount.key}"
              name = "${module.data.namespaceUniqueName}-dashboard-${replace(volume_mount.key, "/.*\\//", "")}"
            }
          }
        }

        container {
          name  = "postgres"
          image = var.postgresImage

          security_context {
            read_only_root_filesystem = false
            allow_privilege_escalation = false
            privileged = false
            run_as_user = 0
            run_as_group = 0
          }

          env {
            name  = "PGDATA"
            value = "/var/lib/postgresql/data/pgdata"
          }

          env {
            name  = "POSTGRES_DB"
            value = "grafana"
          }

          env {
            name  = "POSTGRES_PASSWORD"
            value = random_string.dbPassword.result
          }

          env {
            name  = "POSTGRES_USER"
            value = "grafana"
          }
        }
      }
    }
  }
}
