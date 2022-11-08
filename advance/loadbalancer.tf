# ------------------------------------------------------------------------------
# CREATE A PUBLIC IP ADDRESS
# ------------------------------------------------------------------------------

resource "google_compute_global_address" "default" {
  project      = var.project
  name         = "${var.name}-address"
  ip_version   = "IPV4"
  address_type = "EXTERNAL"
}

# ------------------------------------------------------------------------------
# IF PLAIN HTTP ENABLED, CREATE FORWARDING RULE AND PROXY
# ------------------------------------------------------------------------------

resource "google_compute_target_http_proxy" "http" {
  project = var.project
  name    = "${var.name}-http-proxy"
  url_map = google_compute_url_map.urlmap.self_link
}

resource "google_compute_global_forwarding_rule" "http" {
  project    = var.project
  name       = "${var.name}-http-rule"
  target     = google_compute_target_http_proxy.http.self_link
  ip_address = google_compute_global_address.default.address
  port_range = "80"
}

# ------------------------------------------------------------------------------
# CREATE A FIREWALL TO ALLOW ACCESS FROM THE LB TO THE INSTANCE
# ------------------------------------------------------------------------------

resource "google_compute_firewall" "firewall" {
  project = var.project
  name    = "${var.name}-fw"
  network = "default"

  # Allow load balancer access to the API instances
  source_ranges = ["130.211.0.0/22", "35.191.0.0/16"]

  target_tags = ["private-app"]
  source_tags = ["private-app"]

  allow {
    protocol = "tcp"
    ports    = ["5000","8000"]
  }
}