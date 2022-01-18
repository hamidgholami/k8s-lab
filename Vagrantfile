Vagrant.configure("2") do |config|

    N = 3
	(1..N).each do |machine_id|
		config.vm.define "node-#{machine_id}" do |machine|
			machine.ssh.insert_key = false
			machine.vm.box = "centos/7"
			machine.vm.hostname = "node-#{machine_id}"
			machine.vm.network :private_network , 
				:ip =>  "192.168.11.#{20+machine_id}", 
				:libvirt__forward_mode => "route",
				:libvirt__dhcp_enabled => false
			config.vm.provider "libvirt" do |v|
				v.storage :file, :size => '5G'
				v.storage :file, :size => '5G'
				v.storage :file, :size => '5G'
				v.memory = 2500
				v.cpus = 3
				#v.storage_pool_name = 'pool_myhome_SSD'

		    end

		# Only execute once the Ansible provisioner
		# when all the machines are up and ready.
		if machine_id == N
		  machine.vm.provision :ansible do |ansible|
			# Disable default limit to connect to all the machines
			ansible.limit = "all"
			ansible.playbook = "provisioning/playbook.yml"
			#ansible.verbose = "-v"
			ansible.inventory_path = "provisioning/inventory"

		      end
		   end
		end
	end
end
