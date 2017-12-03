resource "google_dns_managed_zone" "chdotnet" {
  name        = "chdotnet"
  description = "charleshooper.net"
  dns_name    = "charleshooper.net."
}

resource "google_dns_record_set" "chdotnet_root" {
  name = "${google_dns_managed_zone.chdotnet.dns_name}"
  type = "A"
  ttl  = 300

  managed_zone = "${google_dns_managed_zone.chdotnet.name}"

  rrdatas = ["162.243.134.207"]
}

resource "google_dns_record_set" "chdotnet_www" {
  name = "www.${google_dns_managed_zone.chdotnet.dns_name}"
  type = "CNAME"
  ttl  = 300

  managed_zone = "${google_dns_managed_zone.chdotnet.name}"

  rrdatas = ["a.prod.fastly.net."]
}

resource "google_dns_record_set" "chdotnet_txt_gsv" {
  name = "${google_dns_managed_zone.chdotnet.dns_name}"
  type = "TXT"
  ttl  = 300

  managed_zone = "${google_dns_managed_zone.chdotnet.name}"

  rrdatas = ["google-site-verification=W3PJzOUjxdRyUPUWcNl3iN4qlMN7Fqzdthi4FtmIeOc"]
}

output "chdotnet_name_servers" {
  value = "${google_dns_managed_zone.chdotnet.name_servers}"
}
