output "argocd_namespace" {
  value = helm_release.argocd.namespace
}

output "argocd_ui" {
  value = "kubectl -n argocd port-forward svc/argocd-server 8080:80  ->  http://localhost:8080"
}

output "argocd_admin_password" {
  value = "kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d"
}
