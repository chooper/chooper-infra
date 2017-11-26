module "database" {
  source = "./database"
}

resource "google_sql_database" "solarmon_db" {
  name     = "solarmon-db"
  instance = "${module.database.name}"
}

resource "google_sql_user" "solarmon_db_user" {
  name     = "solarmon"
  instance = "${module.database.name}"
  host     = ""

  # TODO(charles) can i reference a secret here instead?
  password = "${var.solarmon_db_user_password}"
}

resource "kubernetes_service" "solarmon" {
  metadata {
    name = "solarmon-web"
  }

  spec {
    selector {
      app = "${kubernetes_pod.solarmon_web.metadata.0.labels.app}"
    }

    port {
      port        = 80
      target_port = "${kubernetes_pod.solarmon_web.spec.0.container.0.port.0.container_port}"
      protocol    = "TCP"
    }

    type = "LoadBalancer"
  }
}

resource "kubernetes_pod" "solarmon_web" {
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
      ]
    }
    container {
      name = "cloudsql-proxy"
      image = "gcr.io/cloudsql-docker/gce-proxy:1.11"
      command = ["/cloud_sql_proxy", "--dir=/cloudsql",
            "-instances=key-chalice-143715:us-west1:primary-db=tcp:5432",
            "-credential_file=/secrets/cloudsql/credentials.json"]
      volume_mount {
        name = "cloudsql-instance-credentials"
        mount_path = "/secrets/cloudsql"
        read_only = true
      }
      volume_mount {
        name = "ssl-certs"
        mount_path = "/etc/ssl/certs"
      }
      volume_mount {
        name = "cloudsql"
        mount_path = "/cloudsql"
      }
    }
    volume {
      name = "cloudsql-instance-credentials"
      secret {
        secret_name = "cloudsql-instance-credentials"
      }
    }
    volume {
      name = "cloudsql"
      empty_dir {}
    }
    volume {
      name = "ssl-certs"
      host_path {
        path = "/etc/ssl/certs"
      }
    }
  }
}

resource "kubernetes_pod" "solarmon_sync" {
  metadata {
    name = "solarmon-sync"

    labels {
      app = "solarmon-sync"
    }
  }

  spec {
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
    container {
      name = "cloudsql-proxy"
      image = "gcr.io/cloudsql-docker/gce-proxy:1.11"
      command = ["/cloud_sql_proxy", "--dir=/cloudsql",
            "-instances=key-chalice-143715:us-west1:primary-db=tcp:5432",
            "-credential_file=/secrets/cloudsql/credentials.json"]
      volume_mount {
        name = "cloudsql-instance-credentials"
        mount_path = "/secrets/cloudsql"
        read_only = true
      }
      volume_mount {
        name = "ssl-certs"
        mount_path = "/etc/ssl/certs"
      }
      volume_mount {
        name = "cloudsql"
        mount_path = "/cloudsql"
      }
    }
    volume {
      name = "cloudsql-instance-credentials"
      secret {
        secret_name = "cloudsql-instance-credentials"
      }
    }
    volume {
      name = "cloudsql"
      empty_dir {}
    }
    volume {
      name = "ssl-certs"
      host_path {
        path = "/etc/ssl/certs"
      }
    }
  }
}
