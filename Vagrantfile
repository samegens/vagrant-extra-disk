Vagrant.configure("2") do |config|
	config.vm.define "extradisk" do |extradisk|
		extradisk.vm.box = "ubuntu/bionic64"
		extradisk.vm.provision "shell", path: "init-extra-disk.sh"
	end

	config.vm.provider "virtualbox" do |vb|
		file_to_disk = 'D:/Virtual Machines/extra_disk.vdi'
		unless File.exist?(file_to_disk)
			# Create the image if it doesn't exist yet.
			# Note that creating the image here will cause the image to be deleted on 'vagrant destroy'.
			# If you don't want that, create the image yourself and just refer to that image.
			# The image will be dynamic by default, the specified disk size is 1 GB.
			vb.customize ['createhd', '--filename', file_to_disk, '--size', 1 * 1024]
		end
		# SCSI Port 1 and 2 are taken bij de actual VM image and the configdrive image, so we put the disk on port 3.
		vb.customize ['storageattach', :id, '--storagectl', 'SCSI', '--port', 3, '--type', 'hdd', '--medium', file_to_disk]
	end
end
