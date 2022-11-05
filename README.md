# Use Terraform to provision a Kubernetes cluster on XCP-NG

Deploy a K3S cluster in your XCP-NG homelab using Terraform. This Terraform config doesn't install Kubernetes, but provisions the master and worker virtual machines so the setup can be completed by another automation tool like Ansible.

## Requirements

- XCP-NG host
- XOA virtual machine (I used the script by [ronivay](https://github.com/ronivay/XenOrchestraInstallerUpdater) to import a VM with XO-CE installed from sources).
- XOA username and password
- XOA ip/url
- VM with Terraform version 0.13.0 or greater installed (I used a [Ubuntu 22.04 LTS cloud image .ova](https://cloud-images.ubuntu.com/releases/jammy/release/) to import a VM into XOA and convert it to a template ready for cloud-init, then installed Terraform).

---

## XenOrchestra Provider

### provider.tf

The XenOrchestra provider for Terraform is configured in provider.tf. Terraform version 0.13.0 or greater is required. The latest version of XenOrchestra provider available when this was written was 0.23.3. It is only tested with that version, but newer versions may be available. If you used the VM import script from ronivay to create your XO-CE vm, you will need to set `insecure = true` in the provider config for Terraform to be able to access XOA. This is not recommended and is just a workaround for now.

---

## Variables

### credentials.auto.tfvars

 - xo_host should be set to your XOA IP/URL. Use wss:// for https and ws:// for http. For the XO-CE VM imported using [ronivay](https://github.com/ronivay/XenOrchestraInstallerUpdater) script, use wss://.
 - xo_user should be set to a user with access to XOA. The default user in XOA is admin@admin.net.
 - xo_pass should be set to the above user's password. The default password in XOA is admin.

### config.auto.tfvars

 - pool_name is the pool_name in XOA, usually the name of your XCP-NG host.
 - network_name is the name of the network you want to use, the default network in XOA is "Pool-wide network associated with eth0"
 - storage_name is the name of the default storage repository you want ot use, the default storage repository in XOA is "Local storage".
 - template_name is the name of the VM template you will be using. In my case I imported [Ubuntu 20.04 LTS](https://cloud-images.ubuntu.com/releases/focal/release/) and converted to template. 20.04 was used because 20.04 is the latest Ubuntu release that still had the xe-guest-utilities packaged with it so you don't have to manually install the guest utilities from XOA.

 - ssh_key is the public ssh key you want to use in cloud-init so you can ssh into the VMs after they are created. Create a new one by running this: `ssh-keygen -t ed25519`

 - netmask is the netmask you can specify in cloud-init. Ex: 255.255.255.0
 - gateway is the default gateway network you can specify in cloud-init. Ex: 192.168.1.1
 - dns is the dns namesever you can specify in cloud-init. Ex: 192.168.1.1

 - num_k3s_masters is the number of k3s master VMs you would like created. The default is 1.
 - num_k3s_workers is the number of k3s worker VMs you would like created. The default is 1.

The following variables are commented out because they were all set to the default, but can be uncommented and set to different values according to your specifications.

 - master_cores = number of CPU cores for each master VM. Default is 4.
 - worker_cores = number of CPU cores for each worker VM. Default is 2.
 - master_memory = amount of RAM for each master VM in BYTES. Default is 4gb.
 - worker_memory = amount of RAM for each worker VM in BYTES. Default is 4gb.
 - storage_size = amount of disk space for each VM in BYTES. Default is 10gb.

---

## Cloud-init Templates

### templates/cloud-config.tftpl

This is a basic cloud-init template that sets the hostname, fqdn, admin user, provided ssh key, installs the xe-guest-utilities package, updates and upgrades all packages, and reboots if necessary for each VM.

### templates/network_config.tftpl

This is a basic cloud-init template that sets the network configuration for each VM. The configuration uses static IP addresses that are defined in the main.tf file. This could be changed to use dhcp to simply the configuration.

---
