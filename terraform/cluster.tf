resource "google_container_cluster" "primary" {
  name               = "chooper-cluster"
  zone               = "us-west1-a"
  initial_node_count = 1

  additional_zones = [
    "us-west1-b",
    "us-west1-c",
  ]

  master_auth {
    username = "${var.cluster_master_username}"
    password = "${var.cluster_master_password}"
  }

  node_config {
    oauth_scopes = [
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
    machine_type = "f1-micro"
  }
}

# The following outputs allow authentication and connectivity to the Google Container Cluster.
output "client_certificate" {
  value = "${google_container_cluster.primary.master_auth.0.client_certificate}"
}

output "client_key" {
  value = "${google_container_cluster.primary.master_auth.0.client_key}"
}

output "cluster_ca_certificate" {
  value = "${google_container_cluster.primary.master_auth.0.cluster_ca_certificate}"
}
