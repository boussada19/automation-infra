
# Terraform - Déploiement VM Windows Server sur vSphere

Ce projet Terraform permet de cloner une VM Windows Server depuis un template sur vCenter.

## ✅ Prérequis

- Un template Windows Server avec VMware Tools
- Accès réseau vers vCenter (`vsphere_server`)
- Terraform installé

## 🚀 Déploiement

```bash
terraform init
terraform plan
terraform apply
```

## 🛠️ Personnalisation

Modifier les variables dans `terraform.tfvars` :
- Nom de la VM
- Adresse IP, RAM, disque
- Nom du datacenter, cluster, etc.
