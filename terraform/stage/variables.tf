variable project {
  description = "Project ID"
}
variable region {
  description = "Region"
  default     = "europe-west1"
}
variable public_key_path {
  description = "Path to the public key used for ssh access"
}
variable disk_image {
  description = "Disk image"
}
variable private_key_path {
  description = "Path to the private key used for ssh access"
}
variable zone {
  description = "Zone"
  default     = "europe-west1-d"
}
variable "public_keys" {
  type        = list
  description = "Pub Keys"
}
variable countIns {
  description = "Count Instance"
  default     = 1
}
variable app_disk_image {
  description = "Disk image for reddit app"
  # default     = "ruby-base-1585913291"
  default = "ruby-base-1586886577"
}
variable db_disk_image {
  description = "Disk image for reddit db"
  # default     = "db-base-1585913708"
  default = "db-base-1586886844"
}
