resource "google_compute_forwarding_rule" "default" {
  name       = "reddir-app-forwarding-rule"
  target     = google_compute_target_pool.default.self_link
  region     = var.region
  project    = var.project
  port_range = "9292"
}

resource "google_compute_target_pool" "default" {
  name    = "reddit-app-pool"
  region  = var.region
  project = var.project

  instances = [
    "europe-west1-d/reddit-app",
    "europe-west1-d/reddit-app2"
  ]

  health_checks = [
    google_compute_http_health_check.default.name,
  ]
}

resource "google_compute_http_health_check" "default" {
  name               = "default"
  request_path       = "/"
  check_interval_sec = 11
  timeout_sec        = 7
  port               = "9292"
}
