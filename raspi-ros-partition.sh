#!/bin/bash

losetup /dev/loop0 *-raspbian-stretch-lite.img
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
