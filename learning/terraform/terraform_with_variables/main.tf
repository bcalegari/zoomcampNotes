terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "6.16.0"
    }
  }
}

provider "google" {
#   credentials = file(var.credentials)
  project     = var.project
  region      = var.region
}


resource "google_storage_bucket" "learning-v001-bucket" {
  name          = var.gcs_bucket
  location      = var.location
  force_destroy = true


  lifecycle_rule {
    condition {
      age = 1
    }
    action {
      type = "AbortIncompleteMultipartUpload"
    }
  }
}



resource "google_bigquery_dataset" "learning_dataset" {
  dataset_id = var.bq_dataset
  location   = var.location
}