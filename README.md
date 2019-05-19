# Roll your own CentOS Atomic Host ISOs

CentOS Atomic Host is designed to use "cloud-init" on the first run to customize the install.

This project creates two ISOs

1. The install ISO, which is a vanilla Centos Atomic Host install

2. The cloud-init ISO, which sets the hostname, etc.

Once the ISO's are created, you can install the OS, then eject the install disk, and use the cloud-init disk.  So only one DVD drive is necessary.

On a virtual system, you can create two DVD drives and stick both disks in.

## "AS-IS"

To use it "as-is" run:

sudo ./create-kickstart.iso

**To find the ISOs:**

grep iso create-kickstart.iso

**Default username and password:**

grep user kickstart.cfg

## To customize the Centos Atomic ISO:

Edit the kickstart.cfg and the cloud-init/user-data file

**To get you started with kickstart, review:**

https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/installation_guide/sect-kickstart-examples

**To get you started with cloud-init, review:**

https://cloudinit.readthedocs.io/en/latest/topics/examples.html

## To change to a different Atomic flavor:

1. Do a manual install of the Atomic system:

 - change the centos references in kickstart.cfg to what is in /root/anaconda-ks.cfg.

2. Extract the contents of the new distribution.  Find the isolinux.cfg.

copy the first stanza of:

label linux
  menu label ^Install Some Atomic Host
  kernel vmlinuz
  append initrd=initrd.img inst.stage2=hd:LABEL=Some\x20Atomic\x20Host\20x86_64 quiet

put it immediately before, and add the **inst.ks=cdrom:/dev/cdrom:/kickstart.cfg** the stanza copied like so:

---

label **is**

  menu label **^Kickstart**

  menu default

  kernel vmlinuz

  append initrd=initrd.img inst.stage2=hd:LABEL=Some\\x20Atomic\\x20Host\\x20x86_64 **inst.ks=cdrom:/dev/cdrom:/kickstart.cfg** quiet


label linux

  menu label ^Install CentOS Atomic Host 7

  kernel vmlinuz

  append initrd=initrd.img inst.stage2=hd:LABEL=Some\\x20Atomic\\x20Host\\x20x86_64 quiet

---

Change the -V option in the create-kickstart.iso to match the label, replacing \x20 with spaces.

Verify the -V is correct, by trying a manual install using the custom image.

