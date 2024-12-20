provider "google" {
  project = var.project_id
  region  = var.region
}

provider "google-beta" {
  project = var.project_id
  region  = var.region
}

resource "google_container_cluster" "minimal" {
  name               = "minimal-gke-cluster"
  location           = var.region
  initial_node_count = 1

  # Remove default node pool to create a custom one with minimal resources
  remove_default_node_pool = true

  # Network settings
  network    = var.network
  subnetwork = var.subnetwork
}

resource "google_container_node_pool" "minimal_nodes" {
  cluster  = google_container_cluster.minimal.name
  location = google_container_cluster.minimal.location
  node_count = 1 # Minimum nodes in the pool

  node_config {
    machine_type = "e2-small" # Smallest available machine type
    disk_type    = "pd-standard"
    disk_size_gb = 10 # Minimal disk size
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }
}

# Variables
variable "project_id" {
  description = "The Google Cloud project ID."
  type        = string
}

variable "region" {
  description = "The region to deploy the GKE cluster in."
  type        = string
  default     = "us-central1"
}

variable "network" {
  description = "The VPC network to use for the GKE cluster."
  type        = string
  default     = "default"
}

variable "subnetwork" {
  description = "The subnetwork to use for the GKE cluster."
  type        = string
  default     = "default"
}
