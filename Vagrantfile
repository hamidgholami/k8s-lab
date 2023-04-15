# encoding: utf-8
# -*- mode: ruby -*-
# vi: set ft=ruby :
IMAGE_DEBIAN_11 = "generic/debian11"
ENV['VAGRANT_NO_PARALLEL'] = 'yes'

provider = (ARGV[2] || ENV['VAGRANT_DEFAULT_PROVIDER'] || :virtualbox).to_sym

Vagrant.configure("2") do |config|

    N = 3
	(1..N).each do |machine_id|
		config.vm.define "node-#{machine_id}" do |machine|
			machine.ssh.insert_key = false
			machine.vm.box = IMAGE_DEBIAN_11
			machine.vm.hostname = "node-#{machine_id}"
			machine.vm.synced_folder '.', '/vagrant', type: 'rsync', disabled: true
			machine.vm.synced_folder '.', '/vagrant', disabled: true
			if provider == :virtualbox then
				machine.vm.network :private_network , :ip =>  "192.168.56.#{20+machine_id}"
				machine.vm.provider "virtualbox" do |vb|
					vb.memory = 1024
					vb.cpus = 1
					vb.name = "node-#{machine_id}"
				end
			end
			if provider == :libvirt then
				machine.vm.network :private_network , :ip =>  "192.168.11.#{20+machine_id}", 
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
			ansible.extra_vars = { ansible_ssh_private_key_file: './provisioning/files/insecure_private_key'}
			# ansible.verbose = "-v"
			if provider == :virtualbox then
				ansible.playbook = "provisioning/site-vb.yml"
			end
			if provider == :libvirt then
				ansible.playbook = "provisioning/site.yml"
			end
			ansible.groups = {
				"kuberlab" => ["node-1", "node-2", "node-3"],
			}
		      end
		   end
		end
	end
end
