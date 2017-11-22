terraform {
  backend "gcs" {
    bucket = "key-chalice-143715.appspot.com"
    prefix = "terraform/state/gke"
  }
}
