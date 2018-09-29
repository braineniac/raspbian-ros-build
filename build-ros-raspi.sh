#!/bin/bash


#extending image
#mknod -m 0660 /dev/loop0 b 0 8
chmod 755 /iso
losetup /dev/loop0 2018-06-27-raspbian-stretch-lite.img
partprobe /dev/loop0
truncate -s +1024M *-raspbian-stretch-lite.img
END=$(fdisk -l | awk '/\/dev\/loop0/ {} END{print $3}')
echo $END
sed -e 's/\s*\([\+0-9a-zA-Z]*\).*/\1/' << EOF | fdisk /dev/loop0
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
mount /dev/loop0p2 /mnt
cp autostart.service /mnt/etc/systemd/system/multi-user.target.wants/
umount /mnt
losetup -d /dev/loop0
cp *-raspbian-stretch-lite.img /iso
#running guest
#sudo qemu-system-arm -kernel qemu-rpi-kernel/kernel-qemu-4.14.50-stretch -cpu arm1176 -m 256M -M versatilepb -dtb qemu-rpi-kernel/versatile-pb.dtb --no-reboot -append "root=/dev/sda2 panic=1 rootfstype=ext4 rw" -net nic -net user,hostfwd=tcp::5022-:22 -hda *-raspbian-stretch-lite.img -hdb swap.img -qmp unix:./qemu/qmp-sock,server,nowait

