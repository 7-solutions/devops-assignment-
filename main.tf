provider "google" {
  project = "your-gcp-project-id"
  region  = "us-central1"
}

provider "google-beta" {
  project = "your-gcp-project-id"
  region  = "us-central1"
}

module "gke" {
  source  = "terraform-google-modules/kubernetes-engine/google"
  project_id = "your-gcp-project-id"
  name       = "sample-go-app-cluster"
  region     = "us-central1"
  network    = module.vpc.network
  subnetwork = module.vpc.subnetwork
}

module "vpc" {
  source  = "terraform-google-modules/network/google"
  project_id   = "your-gcp-project-id"
  network_name = "gke-network"
  subnets = [
    {
      subnet_name   = "gke-subnet"
      subnet_ip     = "10.0.0.0/24"
      region        = "us-central1"
    }
  ]
}
