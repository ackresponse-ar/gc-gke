
// Creates a VPC
resource "google_compute_network" "vpc_network" {
  name                    = var.vpc_name
  auto_create_subnetworks = var.vpc_auto_create_subnets
  mtu                     = var.vpc_mtu
}

// Creates a VPC subnetwork
resource "google_compute_subnetwork" "vpc_network_subnet" {
  name          = var.vpc_subnet_name
  ip_cidr_range = var.vpc_subnet_cidr_range
  region        = var.vpc_subnet_region
  network       = google_compute_network.vpc_network.id
}

// Add ICMP firewall rule
resource "google_compute_firewall" "vpc_firewall_icmp" {
  name    = var.vpc_firewall_icmp_name
  network = google_compute_network.vpc_network.self_link

  allow {
    protocol = var.vpc_firewall_icmp_protocol
  }

  source_ranges = var.vpc_firewall_icmp_source_range
}

// Adds a custom firewall rule
resource "google_compute_firewall" "vpc_firewall_custom" {
  name    = var.vpc_firewall_custom_name
  network = google_compute_network.vpc_network.self_link

  allow {
    protocol = var.vpc_firewall_custom_protocol
  }

  source_ranges = var.vpc_firewall_custom_source_range
}

// Adds a ssh firewall rule
resource "google_compute_firewall" "vpc_firewall_ssh" {
  name    = var.vpc_firewall_ssh_name
  network = google_compute_network.vpc_network.self_link

  allow {
    protocol = var.vpc_firewall_ssh_protocol
    ports    = var.vpc_firewall_ssh_ports
  }

  source_ranges = var.vpc_firewall_ssh_source_range
}

// Adds a rdp firewall rule
resource "google_compute_firewall" "vpc_firewall_rdp" {
  name    = var.vpc_firewall_rdp_name
  network = google_compute_network.vpc_network.self_link

  allow {
    protocol = var.vpc_firewall_rdp_protocol
    ports    = var.vpc_firewall_rdp_port
  }

  source_ranges = var.vpc_firewall_rdp_source_range
}
// Allow internal GKE communication
resource "google_compute_firewall" "allow_internal_gke" {
  name    = "allow-internal-gke"
  network = google_compute_network.vpc_network.self_link

  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }

  source_ranges = ["10.0.1.0/24"] 
}

resource "google_compute_firewall" "allow_ssh" {
  name    = "allow-ssh"
  network = google_compute_network.vpc_network.self_link

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"] 
  target_tags   = ["gke-node"]
}
# GKE Cluster Resource
resource "google_container_cluster" "primary" {
  name       = var.gke_cluster_name
  location   = var.gke_location
  network    = google_compute_network.vpc_network.self_link
  subnetwork = google_compute_subnetwork.vpc_network_subnet.self_link

  # Disables default node pool since we'll create a custom one
  remove_default_node_pool = true
  initial_node_count       = 1

  # Enables alias IP ranges for Pod IPs
  ip_allocation_policy {}

  # Optional: Restrict access to the master using authorized networks
  master_authorized_networks_config {
    cidr_blocks {
      cidr_block   = "0.0.0.0/0" 
      display_name = "global"
    }
  }
}

# GKE Node Pool Resource
resource "google_container_node_pool" "primary_nodes" {
  cluster    = google_container_cluster.primary.name
  location   = var.gke_location
  node_count = var.gke_node_count

  # Node configuration
  node_config {
    machine_type   = var.gke_node_machine_type
    service_account = var.gke_service_account_email
    oauth_scopes   = ["https://www.googleapis.com/auth/cloud-platform"]
    tags           = ["gke-node"]  # This should match firewall rules with 'gke-node' target tags
  }
}
