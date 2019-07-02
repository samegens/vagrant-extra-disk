Vagrant.configure("2") do |config|
	config.vm.define "extradisk" do |extradisk|
		extradisk.vm.box = "ubuntu/bionic64"
		extradisk.vm.hostname = "extradisk"
		extradisk.vm.network "private_network", ip: "192.168.34.10"
		extradisk.vm.boot_timeout = 60
	end

	config.vm.provider "virtualbox" do |vb|
		file_to_disk = 'D:/Virtual Machines/extra_disk.vdi'
		unless File.exist?(file_to_disk)
			vb.customize ['createhd', '--filename', file_to_disk, '--size', 1 * 1024]
		end
		# SCSI Port 1 and 2 are taken bij de actual VM image and the configdrive image.
		vb.customize ['storageattach', :id, '--storagectl', 'SCSI', '--port', 3, '--type', 'hdd', '--medium', file_to_disk]
	end
end
