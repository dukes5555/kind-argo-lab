# Reads connection details from the cluster layer's local state. This keeps
# the two layers independent: the cluster can be recreated without touching
# this code, and this layer never manages the cluster's lifecycle.
data "terraform_remote_state" "cluster" {
  backend = "local"

  config = {
    path = "${path.module}/../cluster/terraform.tfstate"
  }
}

locals {
  cluster = data.terraform_remote_state.cluster.outputs
}

provider "helm" {
  kubernetes = {
    host                   = local.cluster.endpoint
    client_certificate     = local.cluster.client_certificate
    client_key             = local.cluster.client_key
    cluster_ca_certificate = local.cluster.cluster_ca_certificate
  }
}
