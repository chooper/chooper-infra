resource "google_container_cluster" "primary" {
  name               = "chooper-cluster"
  zone               = "us-west1-a"
  initial_node_count = 1

  additional_zones = [
    "us-west1-b",
    "us-west1-c",
  ]

  master_auth {
    username = "${var.master_username}"
    password = "${var.master_password}"
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
