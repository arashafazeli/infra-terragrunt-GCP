output "bucket" {
  description = "The created storage bucket"
  value       = google_storage_bucket.gcpbucket
}

output "name" {
  description = "Bucket name."
  value       = google_storage_bucket.gcpbucket.name
}

output "url" {
  description = "Bucket URL."
  value       = google_storage_bucket.gcpbucket.url
}
