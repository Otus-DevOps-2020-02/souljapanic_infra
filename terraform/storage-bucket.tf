provider "google" {
  version = "2.15"
  project = var.project
  region  = var.region
}

module "storage-bucket" {
  source  = "SweetOps/storage-bucket/google"
  version = "0.3.1"

  name          = "storagebucketsoulja01"
  location      = var.region
  force_destroy = true
}

output storage-bucket_url {
  value = module.storage-bucket.url
}
