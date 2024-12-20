resource "google_container_cluster" "minimal" {
  name               = "minimal-gke-cluster"
  location           = var.region
  initial_node_count = 1
  remove_default_node_pool = true
  network            = var.network
  subnetwork         = var.subnetwork
}

resource "google_container_node_pool" "minimal_nodes" {
  cluster    = google_container_cluster.minimal.name
  location   = google_container_cluster.minimal.location
  node_count = 1

  node_config {
    machine_type = "e2-small"
    disk_type    = "pd-standard" # Avoid SSD quota consumption
    disk_size_gb = 10
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }
}

variable "project_id" {
  type        = string
  description = "The Google Cloud project ID."
}

variable "region" {
  type        = string
  description = "The region to deploy the GKE cluster in."
  default     = "us-east1" # Change region if quota is insufficient
}

variable "network" {
  type        = string
  description = "The VPC network to use for the GKE cluster."
  default     = "default"
}

variable "subnetwork" {
  type        = string
  description = "The subnetwork to use for the GKE cluster."
  default     = "default"
}
