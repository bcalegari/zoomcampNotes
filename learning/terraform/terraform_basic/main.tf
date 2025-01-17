terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "6.16.0"
    }
  }
}

provider "google" {
# Credentials only needs to be set if you do not have the GOOGLE_APPLICATION_CREDENTIALS set
#  credentials = "where key????????"
  project = "learning-v001"
  region  = "europe-southwest1"
}

# 
# 
resource "google_storage_bucket" "learn-bucket" {
  name          = "learning-v001-bucket"
  location      = "EUROPE-WEST1"

  # Optional, but recommended settings:
  storage_class = "STANDARD"
  uniform_bucket_level_access = true

  versioning {
    enabled     = true
  }

  lifecycle_rule {
    action {
      type = "Delete"
    }
    condition {
      age = 30  // days
    }
  }

  force_destroy = true
}
# 
# 
# resource "google_bigquery_dataset" "dataset" {
#   dataset_id = "<The Dataset Name You Want to Use>"
#   project    = "<Your Project ID>"
#   location   = "US"
# }