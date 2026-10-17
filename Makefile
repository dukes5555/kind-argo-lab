CLUSTER_DIR  := terraform/cluster
PLATFORM_DIR := terraform/platform
KUBECONFIG   ?= $(HOME)/.kube/lab-config
export KUBECONFIG

.PHONY: up down reset cluster platform fmt validate argocd-ui argocd-password

up: cluster platform ## Create the cluster and install Argo CD

cluster:
	terraform -chdir=$(CLUSTER_DIR) init -input=false
	terraform -chdir=$(CLUSTER_DIR) apply -auto-approve

platform:
	terraform -chdir=$(PLATFORM_DIR) init -input=false
	terraform -chdir=$(PLATFORM_DIR) apply -auto-approve

# Destroying the cluster removes everything in it, so the platform state is
# simply discarded rather than destroyed release by release.
down:
	terraform -chdir=$(CLUSTER_DIR) destroy -auto-approve
	rm -f $(PLATFORM_DIR)/terraform.tfstate $(PLATFORM_DIR)/terraform.tfstate.backup

reset: down up

fmt:
	terraform fmt -recursive terraform

validate:
	terraform -chdir=$(CLUSTER_DIR) validate
	terraform -chdir=$(PLATFORM_DIR) validate

argocd-ui:
	kubectl -n argocd port-forward svc/argocd-server 8080:80

argocd-password:
	@kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d; echo
