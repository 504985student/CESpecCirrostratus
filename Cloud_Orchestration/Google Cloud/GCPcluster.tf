# VPC Network
resource "google_compute_network" "vpc_network" {
    name                    = "kube-network"
    auto_create_subnetworks = false
}

# Subnetwork with Secondary IP Ranges
resource "google_compute_subnetwork" "subnetwork" {
    name          = "kube-subnet"
    ip_cidr_range = "10.40.0.0/16"
    region        = "europe-west1"
    network       = google_compute_network.vpc_network.name

    secondary_ip_range {
    range_name    = "gke-pods"       # Secondary range for Pods
    ip_cidr_range = "10.41.0.0/16"   # Adjust as needed
    }

    secondary_ip_range {
    range_name    = "gke-services"   # Secondary range for Services
    ip_cidr_range = "10.42.0.0/16"   # Adjust as needed
    }
}

# GKE Cluster with Node Pool Configuration
resource "google_container_cluster" "gke_cluster" {
    name                  = "cloudshirt-gke-cluster"
    location              = "europe-west1"
    remove_default_node_pool = true
    initial_node_count    = 1

    # VPC Network and Subnetwork Configuration
    network               = google_compute_network.vpc_network.name
    subnetwork            = google_compute_subnetwork.subnetwork.name

    # IP Allocation Policy
    ip_allocation_policy {
    cluster_secondary_range_name  = google_compute_subnetwork.subnetwork.secondary_ip_range[0].range_name
    services_secondary_range_name = google_compute_subnetwork.subnetwork.secondary_ip_range[1].range_name
    }
}

# Node Pool for GKE Cluster
resource "google_container_node_pool" "gke_node_pool" {
    cluster   = google_container_cluster.gke_cluster.name
    location  = google_container_cluster.gke_cluster.location
    name      = "cloudshirt-gke-node-pool"

    # Node count and configuration
    node_count = 2  # Set initial number of nodes
    node_config {
    machine_type = "n1-highcpu-2"
    disk_type    = "pd-standard"  # Standard disk type

    # Set scopes for access to Google Cloud APIs
    oauth_scopes = [
        "https://www.googleapis.com/auth/cloud-platform",
    ]
    }
}