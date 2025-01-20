# variable "credentials" {
#   description = "My Credentials"
#   default     = "<Path to your Service Account json file>"
#   #ex: if you have a directory where this file is called keys with your service account json file
#   #saved there as my-creds.json you could use default = "./keys/my-creds.json"
# }


variable "project" {
  description = "Project"
  default     = "learning-v001"
}

variable "region" {
  description = "Region"
  #Update the below to your desired region
  default     = "europe-southwest1"
}

variable "location" {
  description = "Project Location"
  #Update the below to your desired location
  default     = "EUROPE-WEST1"
}

variable "bq_dataset" {
  description = "My BigQuery Dataset Name"
  #Update the below to what you want your dataset to be called
  default     = "learning_dataset"
}

variable "gcs_bucket" {
  description = "My Storage Bucket Name"
  #Update the below to a unique bucket name
  default     = "learning-v001-bucket"
}

variable "gcs_storage_class" {
  description = "Bucket Storage Class"
  default     = "STANDARD"
}