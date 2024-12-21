terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "6.14.1"
    }
    time = {
      source = "hashicorp/time"
      version = "0.9.1"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
  zone = var.zone
  credentials = "keys.json"
}

# Enable Cloud Resource Manager API
resource "google_project_service" "cloud_resource_manager" {
  project = var.project_id
  service = "cloudresourcemanager.googleapis.com"
  disable_dependent_services = true
  disable_on_destroy = false
}

# Add a time delay to allow the API to properly enable
resource "time_sleep" "wait_30_seconds" {
  depends_on = [google_project_service.cloud_resource_manager]
  create_duration = "30s"
}


# Enable Google Photos Library API (depends on Cloud Resource Manager)
resource "google_project_service" "photos_api" {
  project = var.project_id
  service = "photoslibrary.googleapis.com"

  # depends_on = [google_project_service.cloud_resource_manager]

  # Ensure the API is enabled before other resources depend on it
  disable_on_destroy = false

  depends_on = [time_sleep.wait_30_seconds]
}

output "enabled_service" {
  description = "The Google Photos Library API service enabled for the project"
  value       = google_project_service.photos_api.service
}
