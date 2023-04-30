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
        machine.vm.network :private_network, :ip => "192.168.56.1#{30 + machine_id}"
        # machine.vm.network :private_network, :ip => "192.168.56.1#{30 + machine_id}", :name => 'vboxnet0', :adapter => 2
        # machine.vm.network :hostonly, "192.168.50.4", :adapter => 2
        # machine.vm.network :forwarded_port, host: "22#{30 + machine_id}", guest: 22
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
          ###########################################
          ## In case if you want add some extra disks
          ###########################################
          # lv.storage :file, :size => '1G'
          # lv.storage :file, :size => '1G'
          # lv.storage :file, :size => '1G'
          lv.memory = 1024
          lv.cpus = 2
          # lv.storage_pool_name = 'pool_ssd_nvm'
        end
      end
      # Only execute once the Ansible provisioner,
      # when all the machines are up and running.
      if machine_id == N
        machine.vm.provision :ansible do |ansible|
          # ansible.verbose = "-v"
          ansible.playbook = "provisioning/site.yml"
          ansible.limit = "all" # Disable default limit to connect to all the machines
          ansible.host_key_checking = false
          ansible.extra_vars = {
            ansible_ssh_private_key_file: './provisioning/files/insecure_private_key'
          }
          if provider != :libvirt then
            ansible.host_vars = {
              "node-1" => { ansible_ssh_host: "192.168.56.131" },
              "node-2" => { ansible_ssh_host: "192.168.56.132" },
              "node-3" => { ansible_ssh_host: "192.168.56.133" },
            }
          end
          if provider == :libvirt then
            ansible.host_vars = {
              "node-1" => { ansible_ssh_host: "10.0.0.21" },
              "node-2" => { ansible_ssh_host: "10.0.0.22" },
              "node-3" => { ansible_ssh_host: "10.0.0.23" },
            }
          end
          ansible.groups = {
            "kuberlab:children" => ["master", "worker"],
            "master" => ["node-1"],
            "worker" => ["node-[2:3]"]
          }
        end
      end
    end
  end
end
