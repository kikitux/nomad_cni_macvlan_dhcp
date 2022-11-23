# -*- mode: ruby -*-
# vi: set ft=ruby :
#

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/jammy64"

  config.vm.synced_folder "cache", "/var/cache/apt/archives/", create: true, owner: "_apt", group: "root", mount_options: ["dmode=777,fmode=666"]

  config.vm.define "dhcp" do |dhcp|
    dhcp.vm.hostname = "dhcp"
    
    # enp0s8
    dhcp.vm.network "private_network", ip: "192.168.210.10", netmask:"255.255.255.0"

    dhcp.vm.provider "virtualbox" do |v|     
      v.memory = 1024 * 2
      v.cpus = 2
    end
    dhcp.vm.provision "shell", path: "scripts/install_tools.sh"
    dhcp.vm.provision "shell", path: "scripts/install_dnsmasq.sh"
    dhcp.vm.provision "shell", path: "scripts/configure_dnsmasq.sh"
  end

  config.vm.define "server" do |server|
    server.vm.hostname = "server"
    
    # enp0s8
    server.vm.network "private_network", ip: "192.168.210.20", netmask:"255.255.255.0"

    server.vm.provider "virtualbox" do |v|     
      v.memory = 1024 * 2
      v.cpus = 2
    end
    server.vm.provision "shell", path: "scripts/install_tools.sh"
    
    server.vm.provision "shell", env: { "IFACE" => "enp0s8" },
      path: "https://github.com/kikitux/curl-bash/raw/master/consul-1server/consul.sh"
    
    server.vm.provision "shell", env: { "IFACE" => "enp0s8" },
      path: "https://github.com/kikitux/curl-bash/raw/master/nomad-1server/nomad.sh"

  end

  (1..2).each do |i|
    config.vm.define "client#{i}" do |client|
      client.vm.hostname = "client#{i}"

      # enp0s8
      client.vm.network "private_network", ip: "192.168.210.#{30+i}", netmask:"255.255.255.0"

      client.vm.provider "virtualbox" do |v|     
        v.memory = 1024 * 2
        v.cpus = 2
      end

      client.vm.provision "shell", path: "scripts/install_tools.sh"
      client.vm.provision "shell", path: "https://raw.githubusercontent.com/kikitux/curl-bash/master/provision/docker.sh"

      client.vm.provision "shell", env: { "IFACE" => "enp0s8", "LAN_JOIN" => "192.168.210.20" },
        path: "https://raw.githubusercontent.com/kikitux/curl-bash/master/consul-client/consul.sh"

      client.vm.provision "shell", env: { "IFACE" => "enp0s8", "LAN_JOIN" => "192.168.210.20" },
        path: "https://raw.githubusercontent.com/kikitux/curl-bash/master/nomad-client/nomad.sh"

      client.vm.provision "shell", path: "scripts/install_cni.sh"
      client.vm.provision "shell", path: "scripts/configure_cni.sh", run: "always"

    end
  end
end
