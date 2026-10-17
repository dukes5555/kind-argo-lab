# kind-argo-lab

Local Kubernetes + Argo CD + Terraform practice lab. Everything runs on a
[kind](https://kind.sigs.k8s.io/) cluster in Docker — no cloud costs, and a
full rebuild takes a couple of minutes.

## Prerequisites

- Docker Desktop (or OrbStack / Colima) with 6–8 GB RAM allocated
- `terraform` >= 1.9, `kubectl`
- Optional: `kind`, `helm`, `k9s`, `argocd` CLI (Terraform providers cover kind and Helm)

## Quick start

```sh
make up                                  # kind cluster + Argo CD + root app
export KUBECONFIG=~/.kube/lab-config
make argocd-password                     # admin password
make argocd-ui                           # http://localhost:8080 (user: admin)
make down                                # tear it all down
```

Argo CD pulls from this repo on GitHub, so it must be pushed (and public)
before the `root` and `hello` apps can sync.

## Layout

```
terraform/
  cluster/     kind cluster (1 control plane + N workers, host ports 80/443)
  platform/    Argo CD via Helm + the root Application (reads cluster state)
gitops/
  apps/        Application manifests — managed by the root app (app-of-apps)
  workloads/   Kubernetes manifests the Applications point at
```

Terraform owns the cluster and the Argo CD install. Argo CD owns everything
under `gitops/`.

## Roadmap

- [ ] **Phase 1 – Cluster as code:** `make cluster`, inspect state, change `worker_count`, plan/apply/destroy
- [ ] **Phase 2 – Argo CD via Terraform:** `make platform`, explore the layered state with `terraform_remote_state`
- [ ] **Phase 3 – GitOps bootstrap:** push repo, watch `root` → `hello` sync; edit replicas in Git and watch it roll out
- [ ] **Phase 4 – Platform add-ons:** ingress-nginx (`argocd.localtest.me`), metrics-server, cert-manager
- [ ] **Phase 5 – Environments:** Kustomize overlays, ApplicationSets, optional second cluster
- [ ] **Phase 6 – Advanced:** Argo Rollouts, Sealed Secrets, CI (`terraform fmt/validate`, `kubeconform`), drift drills

## Git practice

- Work each phase on its own branch (`feat/phase-1-cluster`, ...) and merge via PR
- Commit in small logical units; use `git add -p` to split mixed changes
- Point Argo CD at a branch (`-var gitops_target_revision=feat/...`) to preview changes before merging
- Try `git rebase -i` to clean up history before a PR, `git revert` to roll back a bad deploy (GitOps rollback!), and `git bisect` to find which commit broke a sync
- Tag stable states (`v0.1.0`) and point Argo CD at a tag
