variable "vpc_name" {
  type    = string
  default = "ar-vpc"
}

variable "vpc_auto_create_subnets" {
  type    = bool
  default = false
}

variable "vpc_mtu" {
  type    = number
  default = 1460
}

variable "vpc_subnet_name" {
  type    = string
  default = "ar-vpc-sub"
}

variable "vpc_subnet_cidr_range" {
  type    = string
  default = "10.0.1.0/24"
}

variable "vpc_subnet_region" {
  type    = string
  default = "europe-west2"
}

variable "vpc_firewall_icmp_name" {
  type    = string
  default = "ar-vpc-allow-icmp"
}

variable "vpc_firewall_icmp_protocol" {
  type    = string
  default = "icmp"
}

variable "vpc_firewall_icmp_source_range" {
  type    = list(string)
  default = ["0.0.0.0/0"]
}

variable "vpc_firewall_custom_name" {
  type    = string
  default = "ar-vpc-allow-custom"
}

variable "vpc_firewall_custom_protocol" {
  type    = string
  default = "all"
}

variable "vpc_firewall_custom_source_range" {
  type    = list(string)
  default = ["10.0.1.0/24"]
}

variable "vpc_firewall_ssh_name" {
  type    = string
  default = "ar-vpc-allow-ssh"
}

variable "vpc_firewall_ssh_protocol" {
  type    = string
  default = "tcp"
}

variable "vpc_firewall_ssh_ports" {
  type    = list(string)
  default = ["22"]
}

variable "vpc_firewall_ssh_source_range" {
  type    = list(string)
  default = ["0.0.0.0/0"]
}


variable "vpc_firewall_rdp_name" {
  type    = string
  default = "ar-vpc-allow-rdp"
}

variable "vpc_firewall_rdp_protocol" {
  type    = string
  default = "tcp"
}

variable "vpc_firewall_rdp_port" {
  type    = list(string)
  default = ["3389"]
}

variable "vpc_firewall_rdp_source_range" {
  type    = list(string)
  default = ["0.0.0.0/0"]
}

variable "project_id" {
  type        = string
  default     = "concepts-demo"  
}

variable "gke_cluster_name" {
  type        = string
  default     = "my-gke-cluster"    
}

variable "gke_location" {
  type        = string
  default     = "europe-west2"  
}

variable "gke_node_count" {
  type        = number
  default     = 1  
}

variable "gke_node_machine_type" {
  type        = string
  default     = "e2-medium"  
}
variable "gke_service_account_email" {
  type        = string
  default     = "pbl-sa@concepts-demo.iam.gserviceaccount.com"
}


