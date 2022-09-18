# Lightweight Kubernetes Labratory

[![Twitter Follow](https://img.shields.io/twitter/follow/045_hamid?label=045_hamid&style=plastic&logo=twitter&color=blue)](https://twitter.com/045_hamid)
[![GitHub Follow](https://img.shields.io/github/followers/hamidgholami?label=hamidgholami&style=plastic&logo=github&color=green)](https://github.com/hamidgholami)
[![Linkedin Badge](https://img.shields.io/badge/hamid--gholami-LinkedIn-blue?logo=linkedin)](https://www.linkedin.com/in/hamid-gholami/)
<!--
[![Youtube Badge](https://img.shields.io/badge/-geekestan-red?style=plastic&&logo=youtube&message=geekestan&logoColor=white)](https://www.youtube.com/channel/UCBlOVqLEwcvFNG03KDAVTlw)
-->

This is a <ins>3-node-cluster</ins> Kubernetes that uses `k3s`. It can be very usefull for learning Kubernetes concepts easy and fast without struggling with installing kubernetes by `kubeadm` or `minikube`. Although learning methods of Kubernetes installation is definitely crucial, for first step and for learning vital and basic concepts of Kubernetes we need a lightweight and repeatable infrastructure.

### Requirement
Make sure that following tools are installed on your host.

1. Ansible
2. Vagrant
3. libvirt/KVM or virtualbox

### How is it work?
Run below commands:
```bash
vagrant up --provider libvirt
# OR
vagrant up --provider virtualbox
```
### Kubeconfig

```
scp -i ./provisioning/files/insecure_private_key vagrant@<node-1-ip>:~/.kube/config ~/.kube/config
```
***

### TO DO
<details> 
<summary> Preview</summary>

- [x] Adding `virtualbox` as a provider in Vagrantfile that dynamicly detect provider(between libvirt and virtualbox)
- [ ] Using sync folder or file for transfer `~/.kube/config` from guest to host.
- [ ] Adding a step-by-step guide line for using it on `windows 10 wsl`. That should contain:
  - [ ] Installing `wsl` on `Windows 10`.
  - [ ] Installing and configuring `vagrant` on `wsl`.
  - [ ] Installing `virtualbox` on `Windows 10`.
  - [ ] Installing `ansible` on `wsl`.
- [ ] Prepare all configurations for `Terraform` and with `AWS` provider.

</details>
