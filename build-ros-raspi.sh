#!/bin/bash

#downloads
wget --no-check-certificate https://downloads.raspberry.org/raspbian_lite_latest
git clone git://git.qemu.org/qemu.git
git clone https://github.com/dhruvvyas90/qemu-rpi-kernel.git

#unpacking
mv raspbian_lite_latest raspi-ros.zip
unzip raspi-ros.zip

#creating images
dd if=/dev/zero of=swap.img bs=1G count=1


#extending image
sudo losetup /dev/loop0 *-raspbian-stretch-lite.img
sudo partprobe /dev/loop0
truncate -s +1024M *-raspbian-stretch-lite.img
END=$(sudo fdisk -l | awk '/\/dev\/loop0/ {} END{print $3}')
echo $END
sudo sed -e 's/\s*\([\+0-9a-zA-Z]*\).*/\1/' << EOF | sudo fdisk /dev/loop0
	d
	2
	n
	p
	2	 
	$(($END +1))
	
	w
	q
EOF

#mounting and copying files
sudo mount /dev/loop0p2 /mnt
cp autostart.service /mnt/etc/systemd/system/multi-user.target.wants/

#running guest
sudo qemu-system-arm -kernel qemu-rpi-kernel/kernel-qemu-4.14.50-stretch -cpu arm1176 -m 256M -M versatilepb -dtb qemu-rpi-kernel/versatile-pb.dtb --no-reboot -append "root=/dev/sda2 panic=1 rootfstype=ext4 rw" -net nic -net user,hostfwd=tcp::5022-:22 -hda *-raspbian-stretch-lite.img -hdb swap.img -qmp unix:./qemu/qmp-sock,server,nowait -daemonize -display none

