variable "cluster_name" {
  description = "Name of the kind cluster (kubectl context becomes kind-<name>)."
  type        = string
  default     = "lab"
}

variable "worker_count" {
  description = "Number of worker nodes alongside the single control-plane node."
  type        = number
  default     = 2

  validation {
    condition     = var.worker_count >= 0 && var.worker_count <= 5
    error_message = "worker_count must be between 0 and 5."
  }
}

variable "node_image" {
  description = "kindest/node image to pin the Kubernetes version. null uses the provider default."
  type        = string
  default     = null
}
