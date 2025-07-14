Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/jammy64"
  config.vm.hostname = "arcade-machine"

  config.vm.network "forwarded_port", guest: 80, host: 8081
  

  config.vm.provision "shell", path: "provision.sh"
end
