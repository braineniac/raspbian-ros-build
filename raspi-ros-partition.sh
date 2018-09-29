#!/bin/bash

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
