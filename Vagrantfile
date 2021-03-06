# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

load 'scripts.rb'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  if Vagrant.has_plugin?("vagrant-cachier")
    config.cache.scope = :box
  end

  config.vm.box = "marathon-flocker-plugin-demo-v1"
  config.vm.box_url = "http://storage.googleapis.com/experiments-clusterhq/vagrant-boxes/marathon-flocker-plugin-demo-v1.box"

  config.vm.define "node1" do |node1|
    node1.vm.network :private_network, :ip => "172.16.79.250"
    node1.vm.hostname = "node1"
    node1.vm.provider "virtualbox" do |v|
      v.memory = 2048
    end

    # these functions are all defined in 'scripts.rb'
    node1.vm.provision :shell, inline: 
      create_zfs_pool() +
      update_hosts("172.16.79.250", "172.16.79.251") +
      add_vagrant_group() +
      install_ssh_keys() +
      copy_control_certs() +
      copy_agent_certs("node1") +
      flocker_control_config() +
      flocker_agent_config("172.16.79.250") +
      flocker_plugin_config("172.16.79.250", "172.16.79.250") + 
      install_mesosphere("master", "172.16.79.250", "172.16.79.250", "disk:spinning") +
      install_mesosphere("slave", "172.16.79.250", "172.16.79.250", "disk:spinning")

  end

  config.vm.define "node2" do |node2|
    node2.vm.network :private_network, :ip => "172.16.79.251"
    node2.vm.hostname = "node2"
    node2.vm.provider "virtualbox" do |v|
      v.memory = 2048
    end

    # these functions are all defined in 'scripts.rb'
    node2.vm.provision :shell, inline: 
      create_zfs_pool() +
      update_hosts("172.16.79.250", "172.16.79.251") +
      add_vagrant_group() +
      install_ssh_keys() +
      copy_agent_certs("node2") +
      flocker_agent_config("172.16.79.250") +
      flocker_plugin_config("172.16.79.250", "172.16.79.251") + 
      install_mesosphere("slave", "172.16.79.250", "172.16.79.251", "disk:ssd")

  end

end
