# Kubernetes Labratory

[![Twitter Follow](https://img.shields.io/twitter/follow/045_hamid?label=045_hamid&style=plastic&logo=twitter&color=blue)](https://twitter.com/045_hamid)
[![GitHub Follow](https://img.shields.io/github/followers/hamidgholami?label=hamidgholami&style=plastic&logo=github&color=green)](https://github.com/hamidgholami)
[![Linkedin Badge](https://img.shields.io/badge/hamid--gholami-LinkedIn-blue?logo=linkedin)](https://www.linkedin.com/in/hamid-gholami/)
<!--
[![Youtube Badge](https://img.shields.io/badge/-geekestan-red?style=plastic&&logo=youtube&message=geekestan&logoColor=white)](https://www.youtube.com/channel/UCBlOVqLEwcvFNG03KDAVTlw)
-->

This is a 3-node-cluster Kubernetes that uses `k3s`.
This project was prepared for *two type of vagrant prividers*:
1. `virtualbox` : Checkout to `virtualbox` branch
2. `libvirt` : Checkout to `main` branch


### Requirement

1. Ansible
2. Vagrant

### How is it work?
Run below command:
```bash
vagrant up
```
### Kubeconfig

```
scp vagrant@master_ip:~/.kube/config ~/.kube/config
```