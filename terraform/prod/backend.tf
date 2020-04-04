terraform {
  backend "gcs" {
    bucket = "soulja_infra_bucket"
    prefix = "tfstate"
  }
}
