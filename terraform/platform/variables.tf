variable "argocd_chart_version" {
  description = "argo/argo-cd Helm chart version."
  type        = string
  default     = "10.10.5"
}

variable "argocd_apps_chart_version" {
  description = "argo/argocd-apps Helm chart version (used to create the root Application)."
  type        = string
  default     = "2.0.7"
}

variable "gitops_repo_url" {
  description = "Git repo Argo CD syncs from. Must be reachable from the cluster (public GitHub is simplest)."
  type        = string
  default     = "https://github.com/dukes5555/kind-argo-lab.git"
}

variable "gitops_target_revision" {
  description = "Branch, tag, or commit Argo CD tracks. Point at a feature branch to test changes before merging."
  type        = string
  default     = "main"
}
