$script = <<SCRIPT
echo I am provisioning...
date > /etc/vagrant_provisioned_at
SCRIPT

Vagrant.configure("2") do |config|
  config.vm.provision "shell", inline: $script
  config.vm.network :forwarded_port, guest: 80, host: 8000
  config.vm.network :forwarded_port, guest: 8000, host: 8000
  config.vm.network "private_network", ip: "192.168.33.101"
  config.vm.synced_folder "/Users/daryakiryanova/Projects/margo-portfolio/", "/web/margo-portfolio"
end

Vagrant::Config.run do |config|
  config.vm.box = "ubuntu/xenial64"
  config.vm.box_url = "https://atlas.hashicorp.com/ubuntu/boxes/xenial64"
  config.vm.provision :shell, :path => "setup/postgresql.sh"
end
