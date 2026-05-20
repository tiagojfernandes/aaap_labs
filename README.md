# aaap_labs

AME Labs for **Azure Automation**, **Azure Update Manager**, **Azure Machine Configuration**, and **Azure Arc-enabled Servers**.

This repository bundles three Terraform-based labs we use as hands-on references for troubleshooting and demos. Each lab lives in its own folder and is self-contained.

## Labs

### [`Azure-VM-as-ARC-Lab/`](Azure-VM-as-ARC-Lab)

Deploys an Azure Windows VM intended to be used as a stand-in for an **Azure Arc-enabled Server** in lab scenarios. Provides resource group, VNet/subnet, NIC with public IP, NSG (HTTP/HTTPS/RDP) and the Windows VM via reusable modules under `modules/`.

- Stack: Terraform + `azurerm`
- Key files: `main.tf`, `variables.tf`, `outputs.tf`, `provider.tf`
- Modules: `resource_group`, `network`, `arc_vm_windows`

### [`azure-automation-scenarios/`](azure-automation-scenarios)

Lab environment for **Azure Automation**. Covers hybrid workers (Windows / Ubuntu / RHEL), runbooks in PowerShell 5.1, PowerShell 7.4, and Python 3.10, plus optional Microsoft Graph API automation.

- Always deployed: Resource Group, Automation Account (system-assigned MI), VNet/subnet
- Optional modules (feature-flagged): `enable_runbooks`, `enable_hybrid_workers`, `enable_graph_api`
- Quick start via Cloud Shell:
  ```bash
  bash <(curl -s https://raw.githubusercontent.com/petarivanov-msft/azure-automation-scenarios/refs/heads/main/init-lab.sh)
  ```
- Terraform code lives under `terraform/`; helper scripts under `scripts/`
- See [azure-automation-scenarios/README.md](azure-automation-scenarios/README.md) for full details

### [`azure-machine-config-lab/`](azure-machine-config-lab)

Lab environment for **Azure Machine Configuration** (guest configuration) and Microsoft Defender for Cloud baselines. Deploys Windows + Linux VMs and assigns the built-in MC prerequisites initiative, the MDC/MCSB security baseline, and optional custom configurations at resource-group scope.

- Stack: Terraform with an environment-per-folder layout (`envs/dev`)
- Modules: `core_rg`, `network`, `compute_windows`, `compute_linux`, `monitoring`, `mc_prereqs`, `mc_mdc_baseline`, `mc_custom_configs`
- Lights up "vulnerabilities in security configuration" findings in Defender for Cloud

## Repository Layout

```
.
├── Azure-VM-as-ARC-Lab/          # Windows VM used as ARC-server stand-in
├── azure-automation-scenarios/   # Automation Account + hybrid workers + runbooks
├── azure-machine-config-lab/     # Machine Configuration + MDC baselines
└── README.md
```

## Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform/downloads) >= 1.3
- [Azure CLI](https://learn.microsoft.com/cli/azure/install-azure-cli), authenticated via `az login`
- Contributor on the target subscription / resource group (some scenarios require additional Entra ID roles — see each lab's README)

## Usage

Each lab is deployed independently. Change into the lab folder (or its `terraform/` / `envs/dev` subfolder) and run the standard Terraform workflow:

```bash
cd <lab-folder>
terraform init
terraform plan
terraform apply
```

Refer to the README inside each lab folder for variables, feature flags, and any extra prerequisites.
