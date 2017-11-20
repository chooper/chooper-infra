provider "google" {
  version = "~> 1.2"

  project = "key-chalice-143715"
  region  = "us-west1"
}

provider "kubernetes" {
  version = "~> 1.0"

  username = "${var.cluster_master_username}"
  password = "${var.cluster_master_password}"
  host     = "http://${google_container_cluster.primary.endpoint}"

  client_certificate     = "${google_container_cluster.primary.master_auth.0.client_certificat}"
  client_key             = "${google_container_cluster.primary.master_auth.0.client_key}"
  cluster_ca_certificate = "${google_container_cluster.primary.master_auth.0.cluster_ca_certificate}"
}
