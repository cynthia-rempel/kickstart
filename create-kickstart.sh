#!/bin/bash
# https://sysadminonline.net/centos-7-kickstart-unattended-installation-iso/
wget -nc https://cloud.centos.org/centos/7/atomic/images/CentOS-Atomic-Host-Installer.iso
# Create the cloud-init disk
mkdir -p /var/tmp/media/
cd cloud-init
genisoimage \
  -output /var/tmp/media/atomic01-cidata.iso \
  -volid cidata \
  -joliet \
  -rock user-data meta-data
cd ..
mkdir -p /media/mydrive
mount -t iso9660 -o loop ./CentOS-Atomic-Host-Installer.iso /media/mydrive
mkdir -p /var/tmp/media/mydrive
# cp -pRf /media/mydrive/ /var/tmp/media/mydrive/
rsync -av /media/mydrive/ /var/tmp/media/mydrive/
umount /media/mydrive
cp atomic-host/kickstart.cfg /var/tmp/media/mydrive/
cp atomic-host/isolinux.cfg /var/tmp/media/mydrive/isolinux/
cd /var/tmp/media/mydrive
# if there's trouble, check the vanilla boot option
# make sure the -V option matches the lable in isolinux.cfg
mkisofs -r -T -J \
  -V "CentOS Atomic Host 7 x86_64" \
  -b isolinux/isolinux.bin \
  -c isolinux/boot.cat \
  -no-emul-boot \
  -boot-load-size 4 \
  -boot-info-table \
  -o ../centos-7-custom.iso .
implantisomd5 /var/tmp/media/centos-7-custom.iso
file -sL /var/tmp/media/centos-7-custom.iso
chown 1000:1000 /var/tmp/media/centos-7-custom.iso
chown 1000:1000 /var/tmp/media/atomic01-cidata.iso
