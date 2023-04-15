# Lightweight Kubernetes Labratory

[![Twitter Follow](https://img.shields.io/twitter/follow/045_hamid?label=045_hamid&style=plastic&logo=twitter&color=blue)](https://twitter.com/045_hamid)
[![GitHub Follow](https://img.shields.io/github/followers/hamidgholami?label=hamidgholami&style=plastic&logo=github&color=green)](https://github.com/hamidgholami)
[![Linkedin Badge](https://img.shields.io/badge/hamid--gholami-LinkedIn-blue?logo=linkedin)](https://www.linkedin.com/in/hamid-gholami/)
<!--
[![Youtube Badge](https://img.shields.io/badge/-geekestan-red?style=plastic&&logo=youtube&message=geekestan&logoColor=white)](https://www.youtube.com/channel/UCBlOVqLEwcvFNG03KDAVTlw)
-->

This is a <ins>3-node-cluster</ins> Kubernetes that uses `k3s`. It can be very usefull for learning Kubernetes concepts easy and fast without struggling with installing kubernetes by `kubeadm` or `minikube`. Although learning methods of Kubernetes installation is definitely crucial, for first step and for learning vital and basic concepts of Kubernetes we need a lightweight and repeatable infrastructure.

#### Requirement
Make sure that following tools are installed on your host.

1. Ansible
2. Vagrant
3. libvirt/KVM or virtualbox

#### How is it work?
Run below commands:
```bash
vagrant up --provider libvirt
# OR
vagrant up --provider virtualbox
```
#### Kubeconfig

```
scp -i ./provisioning/files/insecure_private_key vagrant@<node-1-ip>:~/.kube/config ~/.kube/config
```
***
#### Changing default storage pool directory
[URL](https://serverfault.com/questions/840519/how-to-change-the-default-storage-pool-from-libvirt)

```bash
virsh pool-list
virsh pool-destroy default
virsh pool-undefine default
virsh pool-define-as --name default --type dir --target /hdd/pool_ssd_nvm
virsh pool-autostart default
virsh pool-start default
```

### TO DO
<details> 
<summary> Preview</summary>

- [ ] Using sync folder or file for transfer `~/.kube/config` from guest to host.
- [ ] Adding `k get cs`, `k cluster-info` and `k version` in Ansible
- [ ] Parameterized Kubernetes version. Using `Debian 11` as a vagrant box, instead of `Centos7`

</details>
