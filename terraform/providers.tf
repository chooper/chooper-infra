provider "google" {
  version = "~> 1.2"

  project = "key-chalice-143715"
  region  = "us-west1"
}

module "cluster" {
  source          = "./cluster"
  master_username = "${var.cluster_master_username}"
  master_password = "${var.cluster_master_password}"
}

provider "kubernetes" {
  version = "~> 1.0"

  username = "${module.cluster.master_username}"
  password = "${module.cluster.master_password}"
  host     = "http://${module.cluster.endpoint}"

  client_certificate     = "${base64decode(module.cluster.client_certificate)}"
  client_key             = "${base64decode(module.cluster.client_key)}"
  cluster_ca_certificate = "${base64decode(module.cluster.cluster_ca_certificate)}"
}
