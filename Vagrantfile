# encoding: utf-8
# -*- mode: ruby -*-
# vi: set ft=ruby :
Vagrant.require_version ">= 2.3.4"
VAGRANTFILE_API_VERSION = "2"

require 'yaml'
vagrant_variables = servers = YAML.load_file('vagrant_variables.yaml')
if vagrant_variables['debug'] then
  puts "Config: #{vagrant_variables.inspect}\n\n"
end
############################ LOADING VAGRANT VARIABLES #################################
BOX                       = vagrant_variables['vagrant_box']
CPU                       = vagrant_variables['cpu']
MEMORY                    = vagrant_variables['memory']
SHELL_PROVISION_FILE_PATH = vagrant_variables['vagrant_shell_provision_file_path']
VM_NAME                   = vagrant_variables['vm_prefix_name']
VM_NUMBERS                = vagrant_variables['vm_numbers']
EXTRA_STORAGE             = vagrant_variables['extra_storage']
EXTRA_STORAGE_SIZE        = vagrant_variables['storage_size']
PROVIDER                  = vagrant_variables['provider']

LIBVIRT_BOX_URL          = vagrant_variables['libvirt']['vagrant_box_url']
LIBVIRT_IP_LAST_OCTET    = vagrant_variables['libvirt']['ip_last_octet']
LIBVIRT_IP_PREFIX        = vagrant_variables['libvirt']['private_network_ip_prefix']
VIRTUALBOX_BOX_URL       = vagrant_variables['virtualbox']['vagrant_box_url']
VIRTUALBOX_IP_LAST_OCTET = vagrant_variables['virtualbox']['ip_last_octet']
VIRTUALBOX_IP_PREFIX     = vagrant_variables['virtualbox']['private_network_ip_prefix']

PLAYBOOK             = vagrant_variables['ansible_playbook']
SSH_PRIVATE_KEY_FILE = vagrant_variables['ansible_ssh_private_key_file']
DEBUG                = vagrant_variables['debug']
VERBOSITY            = vagrant_variables['ansible_verbose']
#########################################################################################
ENV['VAGRANT_NO_PARALLEL'] = vagrant_variables['vagrant_no_parallel']

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  N = VM_NUMBERS
  (1..N).each do |machine_id|
    config.vm.define "#{VM_NAME}-#{machine_id}" do |machine|
      machine.ssh.insert_key = false
      machine.vm.box = BOX
      machine.vm.hostname = "#{VM_NAME}-#{machine_id}"
      machine.vm.synced_folder '.', '/vagrant', type: 'rsync', disabled: true
      machine.vm.synced_folder '.', '/vagrant', disabled: true
      machine.vm.provision "shell", path: SHELL_PROVISION_FILE_PATH

      if PROVIDER == 'virtualbox' then
        machine.vm.box_url = VIRTUALBOX_BOX_URL
        machine.vm.network :private_network, :ip => "#{VIRTUALBOX_IP_PREFIX}.#{VIRTUALBOX_IP_LAST_OCTET + machine_id}"
        machine.vm.provider "virtualbox" do |vb|
          vb.memory = MEMORY
          vb.cpus = CPU
          vb.name = "#{VM_NAME}-#{machine_id}"
        end
      end

      if PROVIDER == 'libvirt' then
        machine.vm.box_url = LIBVIRT_BOX_URL
        machine.vm.network :private_network, :ip => "#{LIBVIRT_IP_PREFIX}.#{LIBVIRT_IP_LAST_OCTET + machine_id}",
                           :libvirt__forward_mode => "route",
                           :libvirt__dhcp_enabled => false
        machine.vm.provider "libvirt" do |lv|
          lv.memory = MEMORY
          lv.cpus = CPU
          if EXTRA_STORAGE then
            lv.storage :file, :size => EXTRA_STORAGE_SIZE
          end
          # lv.storage_pool_name = 'pool_ssd_nvm'
        end
      end

      if machine_id == N
        machine.vm.provision :ansible do |ansible|
          if DEBUG then
            ansible.verbose = VERBOSITY
          end
          ansible.playbook = PLAYBOOK
          ansible.limit = "all"
          ansible.host_key_checking = false
          ansible.extra_vars = {
            ansible_ssh_private_key_file: SSH_PRIVATE_KEY_FILE
          }
          if PROVIDER == 'virtualbox' then
            ansible.host_vars = {
              "node-1" => {
                ansible_ssh_host: "#{VIRTUALBOX_IP_PREFIX}.#{VIRTUALBOX_IP_LAST_OCTET + 1}",
                ansible_host: "#{VIRTUALBOX_IP_PREFIX}.#{VIRTUALBOX_IP_LAST_OCTET + 1}",
                ansible_port: "22"
              },
              "node-2" => {
                ansible_ssh_host: "#{VIRTUALBOX_IP_PREFIX}.#{VIRTUALBOX_IP_LAST_OCTET + 2}",
                ansible_host: "#{VIRTUALBOX_IP_PREFIX}.#{VIRTUALBOX_IP_LAST_OCTET + 2}",
                ansible_port: "22"
              },
              "node-3" => {
                ansible_ssh_host: "#{VIRTUALBOX_IP_PREFIX}.#{VIRTUALBOX_IP_LAST_OCTET + 3}",
                ansible_host: "#{VIRTUALBOX_IP_PREFIX}.#{VIRTUALBOX_IP_LAST_OCTET + 3}",
                ansible_port: "22"
              },
            }
          end
          if PROVIDER == 'libvirt' then
            ansible.host_vars = {
              "node-1" => { ansible_ssh_host: "#{LIBVIRT_IP_PREFIX}.#{LIBVIRT_IP_LAST_OCTET + 1}" },
              "node-2" => { ansible_ssh_host: "#{LIBVIRT_IP_PREFIX}.#{LIBVIRT_IP_LAST_OCTET + 2}" },
              "node-3" => { ansible_ssh_host: "#{LIBVIRT_IP_PREFIX}.#{LIBVIRT_IP_LAST_OCTET + 3}" },
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
