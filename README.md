# Lightweight Kubernetes Labratory

[![Twitter Follow](https://img.shields.io/twitter/follow/045_hamid?label=045_hamid&style=plastic&logo=twitter&color=blue)](https://twitter.com/geekestan)
[![GitHub Follow](https://img.shields.io/github/followers/hamidgholami?label=hamidgholami&style=plastic&logo=github&color=green)](https://github.com/hamidgholami)
[![Linkedin Badge](https://img.shields.io/badge/hamid--gholami-LinkedIn-blue?logo=linkedin)](https://www.linkedin.com/in/hamid-gholami/)
[![Youtube Badge](https://img.shields.io/badge/-geekestan-red?style=plastic&&logo=youtube&message=geekestan&logoColor=white)](https://www.youtube.com/channel/@geekestan)


This is a <ins>3-node-cluster</ins> Kubernetes that uses `k3s`. It can be very usefull for learning Kubernetes concepts easy and fast without struggling with installing kubernetes by `kubeadm` or `minikube`. Although learning methods of Kubernetes installation is definitely crucial, for first step and for learning vital and basic concepts of Kubernetes we need a lightweight and repeatable infrastructure.

#### Requirement
Make sure that following tools are installed on your host.

1. Ansible
2. Vagrant
3. libvirt/KVM or virtualbox

#### SSH configuration
Add the following configuration in `~/.ssh/config`
```bash
Host 10.0.0.*
        Hostname %h

Host 192.168.56.*                     
        Hostname %h
                                               
Match Host 10.0.0.*
        User vagrant                 
        Port 22
        UserKnownHostsFile /dev/null     
        StrictHostKeyChecking no
        PasswordAuthentication no
        IdentityFile /home/hamidgholami/.vagrant.d/insecure_private_key
        IdentitiesOnly yes                                                                     
        LogLevel FATAL          
                                               
Match Host 192.168.56.*
        User vagrant                                                                           
        Port 22                                                                                
        UserKnownHostsFile /dev/null                                                           
        StrictHostKeyChecking no
        PasswordAuthentication no                                                              
        IdentityFile /home/hamidgholami/.vagrant.d/insecure_private_key
        IdentitiesOnly yes                                                                     
        LogLevel FATAL

```
#### How does it work?
Fill the variables in `vagrant_variables.yaml` and then execute the following command:
```bash
vagrant up
```
#### Kubeconfig
For executing `kubectl` from your machine rather than in master node (`node-1`), copy the kubectl configuration in your machine:
```
scp vagrant@<node-1-ip>:~/.kube/config ~/.kube/config
```
#### Changing default storage pool directory
[URL](https://serverfault.com/questions/840519/how-to-change-the-default-storage-pool-from-libvirt)<br/>
For changing storage pool default path, the following commands can be used:
```bash
virsh pool-list
virsh pool-destroy default
virsh pool-undefine default
virsh pool-define-as --name default --type dir --target /hdd/pool_ssd_nvm
virsh pool-autostart default
virsh pool-start default
```
