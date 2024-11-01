resource "google_compute_network" "vpc_network" {
    name                    = "kube-network"
    auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnetwork" {
    name          = "kube-subnet"
    ip_cidr_range = "10.40.0.0/16"
    region        = "us-central1"
    network       = google_compute_network.vpc_network.name

    secondary_ip_range {
    range_name    = "gke-pods"     # Secondary range for Pods
    ip_cidr_range = "10.41.0.0/16"  # Adjust this as needed
    }

    secondary_ip_range {
    range_name    = "gke-services"  # Secondary range for Services
    ip_cidr_range = "10.42.0.0/16"  # Adjust this as needed
    }
}

resource "google_container_cluster" "gke_cluster" {
    name     = "gke-example"
    location = "us-central1"

    initial_node_count = 1

    remove_default_node_pool = true

    # Specify network and subnetwork
    network    = google_compute_network.vpc_network.name
    subnetwork = google_compute_subnetwork.subnetwork.name

    # Specify IP allocation policy
    ip_allocation_policy {
    cluster_secondary_range_name  = google_compute_subnetwork.subnetwork.secondary_ip_range[0].range_name
    services_secondary_range_name = google_compute_subnetwork.subnetwork.secondary_ip_range[1].range_name
    }
}

resource "google_container_node_pool" "gke_node_pool" {
    cluster   = google_container_cluster.gke_cluster.name
    location  = google_container_cluster.gke_cluster.location
    name      = "gke-example-node-pool"

    node_count  = 5  # Set number of replicas
    node_config {
    machine_type = "n1-standard-4"
    disk_type    = "pd-standard"  # Use standard disk type

    oauth_scopes = [
        "https://www.googleapis.com/auth/cloud-platform",
    ]
    }
}