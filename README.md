# Kubernetes Labratory

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