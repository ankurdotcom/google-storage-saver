resource "google_project_service" "photos_library_api" {
    project = var.project_id
    service = "photoslibrary.googleapis.com"
}
output "photos_library_api" {
    value = google_project_service.photos_library_api.id
}