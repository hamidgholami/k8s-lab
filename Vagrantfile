# encoding: utf-8
# -*- mode: ruby -*-
# vi: set ft=ruby :

ENV['VAGRANT_NO_PARALLEL'] = 'yes'

PROVIDER = ["virtualbox", "libvirt"]

Vagrant.configure("2") do |config|

    N = 3
	(1..N).each do |machine_id|
		config.vm.define "node-#{machine_id}" do |machine|
			machine.ssh.insert_key = false
			machine.vm.box = "centos/7"
			machine.vm.hostname = "node-#{machine_id}"

			if PROVIDER == "virtualbox" then
				machine.vm.network :private_network , :ip =>  "192.168.56.#{20+machine_id}"
				machine.vm.network "forwarded_port", guest: 6443, host: 6443 
				machine.vm.network "forwarded_port", guest: 80, host: 80
				machine.vm.network "forwarded_port", guest: 8080, host: 8080
				machine.vm.network "forwarded_port", guest: 443, host: 443
				machine.vm.network "forwarded_port", guest: 8443, host: 8443
				machine.vm.provider "virtualbox" do |v|
					v.memory = 1024
					v.cpus = 1
					#v.storage_pool_name = 'pool_myhome_SSD'
				end
			elsif PROVIDER == "libvirt" then
				machine.vm.network :private_network , :ip =>  "192.168.11.#{20+machine_id}", :libvirt__forward_mode => "route",	:libvirt__dhcp_enabled => false
				machine.vm.provider "libvirt" do |v|
					# These disks are used for installing distributed storage tools such as: rook-ceph, longhorn
					v.storage :file, :size => '1G'
					v.storage :file, :size => '1G'
					v.storage :file, :size => '1G'
					v.memory = 1024
					v.cpus = 2
					#v.storage_pool_name = 'pool_myhome_SSD'
				end
			end
		# Only execute once the Ansible provisioner
		# when all the machines are up and ready.
		if machine_id == N
		  machine.vm.provision :ansible do |ansible|
			# Disable default limit to connect to all the machines
			ansible.limit = "all"
			ansible.host_key_checking = false
			ansible.extra_vars = { ansible_ssh_private_key_file: './provisioning/files/insecure_private_key'}
			ansible.playbook = "provisioning/site.yml"
			ansible.verbose = "-v"
			# ansible.inventory_path = "provisioning/inventory"
			ansible.groups = {
				"kuberlab" => ["node-1", "node-2", "node-3"],
				# "machine" => {
				# 	"master" => "ansible_host=172.10.10.21"
				# }
			}
		      end
		   end
		end
	end
end
