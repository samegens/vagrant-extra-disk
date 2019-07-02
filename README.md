Tested with VirtualBox 6.0.8 and Vagrant 2.2.4.

To create the VM

    vagrant up
    
To open a shell in the VM

    vagrant ssh
    
To destroy the VM

    vagrant destroy -f

The extra disk will be created as /dev/sdc. A partition will be created and mounted at /mnt/extradisk.
