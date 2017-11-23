resource "kubernetes_service" "solarmon" {
  metadata {
    name = "solarmon-web"
  }

  spec {
    selector {
      app = "${kubernetes_pod.solarmon.metadata.0.labels.app}"
    }

    port {
      port        = 80
      target_port = "${kubernetes_pod.solarmon.spec.0.container.0.port.0.container_port}"
      protocol    = "TCP"
    }

    type = "LoadBalancer"
  }
}

resource "kubernetes_pod" "solarmon" {
  metadata {
    name = "solarmon-web"

    labels {
      app = "solarmon-web"
    }
  }

  spec {
    container {
      name = "solarmon-web"

      image             = "chooper/solarmon:latest"
      image_pull_policy = "Always"
      command           = ["rackup", "-p", "8080", "-o", "0.0.0.0"]

      port = [
        {
          container_port = 8080
        },
      ]

      env = [
        {
          name = "DATABASE_URL"

          value_from {
            secret_key_ref {
              name = "solarmon-database"
              key  = "url"
            }
          }
        },
        {
          name = "SOLAREDGE_API_KEY"

          value_from {
            secret_key_ref {
              name = "solarmon-api-creds"
              key  = "api-key"
            }
          }
        },
        {
          name = "SOLAREDGE_SITE_ID"

          value_from {
            secret_key_ref {
              name = "solarmon-api-creds"
              key  = "site-id"
            }
          }
        },
        {
          name  = "TZ"
          value = "America/Los_Angeles"
        },
      ]
    }

    container {
      name = "solarmon-sync"

      image             = "chooper/solarmon:latest"
      image_pull_policy = "Always"
      command           = ["bin/sync_loop"]

      env = [
        {
          name = "DATABASE_URL"

          value_from {
            secret_key_ref {
              name = "solarmon-database"
              key  = "url"
            }
          }
        },
        {
          name = "SOLAREDGE_API_KEY"

          value_from {
            secret_key_ref {
              name = "solarmon-api-creds"
              key  = "api-key"
            }
          }
        },
        {
          name = "SOLAREDGE_SITE_ID"

          value_from {
            secret_key_ref {
              name = "solarmon-api-creds"
              key  = "site-id"
            }
          }
        },
        {
          name  = "TZ"
          value = "America/Los_Angeles"
        },
      ]
    }
  }
}
