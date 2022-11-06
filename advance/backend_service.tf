# ------------------------------------------------------------------------------
# CREATE THE BACKEND SERVICE CONFIGURATION FOR THE INSTANCE GROUP
# ------------------------------------------------------------------------------

resource "google_compute_backend_service" "api" {
  project = var.project

  name        = "${var.name}-api"
  description = "API Backend for ${var.name}"
  port_name   = "http"
  protocol    = "HTTP"
  timeout_sec = 10
  enable_cdn  = false

  backend {
    group = google_compute_instance_group.api.self_link
  }

  health_checks = [google_compute_health_check.default.self_link]
}

resource "google_compute_backend_service" "game" {
  project = var.project

  name        = "${var.name}-game"
  description = "GAME Backend for ${var.name}"
  port_name   = "game"
  protocol    = "HTTP"
  timeout_sec = 10
  enable_cdn  = false

  backend {
    group = google_compute_instance_group.api.self_link
  }

  health_checks = [google_compute_health_check.default.self_link]
}

# ------------------------------------------------------------------------------
# CREATE THE INSTANCE GROUP WITH A SINGLE INSTANCE AND THE BACKEND SERVICE CONFIGURATION
# ------------------------------------------------------------------------------

resource "google_compute_instance_group" "api" {
  project   = var.project
  name      = "${var.name}-instance-group"
  zone      = var.zone
  instances = [google_compute_instance.api.self_link] #TODO : CHANGE with data

  lifecycle {
    create_before_destroy = true
  }

  named_port {
    name = "http"
    port = 5000
  }
  named_port {
    name = "game"
    port = 8000
  }
}

## TODO : Add datasource

# ------------------------------------------------------------------------------
# CONFIGURE HEALTH CHECK FOR THE API BACKEND
# ------------------------------------------------------------------------------

resource "google_compute_health_check" "default" {
  project = var.project
  name    = "${var.name}-hc"

  http_health_check {
    port         = 5000
    request_path = "/api"
  }

  check_interval_sec = 5
  timeout_sec        = 5
}