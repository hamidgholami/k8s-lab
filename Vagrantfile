# encoding: utf-8
# -*- mode: ruby -*-
# vi: set ft=ruby :
IMAGE_DEBIAN_11 = "generic/debian11"
provider = (ARGV[2] || ENV['VAGRANT_DEFAULT_PROVIDER'] || :virtualbox).to_sym
ENV['VAGRANT_NO_PARALLEL'] = 'yes'

Vagrant.configure("2") do |config|

  N = 3
  (1..N).each do |machine_id|
    config.vm.define "node-#{machine_id}" do |machine|
      machine.ssh.insert_key = false
      machine.vm.box = IMAGE_DEBIAN_11
      machine.vm.hostname = "node-#{machine_id}"
      machine.vm.synced_folder '.', '/vagrant', type: 'rsync', disabled: true
      machine.vm.synced_folder '.', '/vagrant', disabled: true
      machine.vm.provision "shell", path: "provisioning/bootstrap.sh"
      if provider != :libvirt then
        machine.vm.network :private_network, :ip => "10.0.0.#{30 + machine_id}"
        machine.vm.network :forwarded_port, host: "22#{30 + machine_id}", guest: 22
        machine.vm.provider "virtualbox" do |vb|
          vb.memory = 1024
          vb.cpus = 1
          vb.name = "node-#{machine_id}"
        end
      end
      if provider == :libvirt then
        machine.vm.network :private_network, :ip => "10.0.0.#{20 + machine_id}",
                           :libvirt__forward_mode => "route",
                           :libvirt__dhcp_enabled => false
        machine.vm.provider "libvirt" do |lv|
          ## These disks are used for installing
          ## distributed storage tools such as: rook-ceph, longhorn
          # lv.storage :file, :size => '1G'
          # lv.storage :file, :size => '1G'
          # lv.storage :file, :size => '1G'
          lv.memory = 1024
          lv.cpus = 2
          # lv.storage_pool_name = 'pool_ssd_nvm'
        end
      end
      # Only execute once the Ansible provisioner
      # when all the machines are up and ready.
      if machine_id == N
        machine.vm.provision :ansible do |ansible|
          # Disable default limit to connect to all the machines
          ansible.limit = "all"
          ansible.host_key_checking = false
          ansible.extra_vars = {
            ansible_ssh_private_key_file: './provisioning/files/insecure_private_key'
          }
          # ansible.verbose = "-v"
          if provider != :libvirt then
            ansible.playbook = "provisioning/site-vb.yml"
            ansible.groups = {
              "kuberlab:children" => ["master", "worker1", "worker2"],
              "master" => ["node-1"],
              "worker1" => ["node-2"],
              "worker2" => ["node-3"],
              "master:vars" => {
                ansible_connection: "local",
                ansible_port: "2231"
              },
              "worker1:vars" => {
                ansible_connection: "local",
                ansible_port: "2232"
              },
              "worker2:vars" => {
                ansible_connection: "local",
                ansible_port: "2233"
              }
            }
          end
          if provider == :libvirt then
            ansible.playbook = "provisioning/site.yml"
            ansible.groups = {
              "kuberlab:children" => ["master", "worker1", "worker2"],
              "master" => ["node-1"],
              "worker1" => ["node-2"],
              "worker2" => ["node-3"],
              "master:vars" => { ansible_ssh_host: "10.0.0.21" },
              "worker1:vars" => { ansible_ssh_host: "10.0.0.22" },
              "worker2:vars" => { ansible_ssh_host: "10.0.0.23" }
            }
          end
        end
      end
    end
  end
end
