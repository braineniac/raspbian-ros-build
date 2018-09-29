FROM archlinux/base:latest
MAINTAINER Daniel Hammer (braineniac@protonmail.com)
RUN pacman -Syu --noconfirm
RUN pacman -S wget --noconfirm
RUN wget http://ftp.jaist.ac.jp/pub/raspberrypi/raspbian/images/raspbian-2018-06-29/2018-06-27-raspbian-stretch.zip
RUN pacman -S git --noconfirm
RUN git clone git://git.qemu.org/qemu.git
RUN git clone https://github.com/dhruvvyas90/qemu-rpi-kernel.git
RUN pacman -S unzip --noconfirm
RUN unzip 2018-06-27-raspbian-stretch.zip
RUN dd if=/dev/zero of=swap.img bs=1G count=1
COPY raspi-ros-partition.sh .
RUN pacman -S awk parted qemu-arch-extra qemu-headless --noconfirm
COPY autostart.service .
COPY build-ros-raspi.sh .

ENTRYPOINT ["/build-ros-raspi.sh"]
#RUN mount --bind /dev /dev
#RUN losetup /dev/loop0 swap.img
#CMD ["./raspi-ros-partition.sh"]
#RUN mount /dev/loop0p2 /mnt
#COPY autostart.service /mnt/etc/systemd/system/multi-user.target.wants
#CMD ["qemu-system-arm", \
#	 "-kernel", "qemu-rpi-kenel/kernel-qemu-4.14.50-stretch", \
#	 "-cpu", "arm1176", \
#	 "-m", "256M", \ 
#	 "-M", "versatilepb" \
#	 "-dbt", "qemu-rpi-kernel/versatile-pb.dtb" \
#	 "--no-reboot" \
#	 "-append", "\"root=/dev/sda2 panic=1 rootfstype=ext4 rw\"" \
#	 "-net", "nic", "user,hostfwd=tcp::5022-:22" \
#	 "-hda", "*-raspbian-stretch-lite.img" \
#	 "-hdb", "swap.img" \
#	 "-qmp", "unix:./qemu/qmp-sock,server,nowait" \
#	 "-daemonize" \
#	 "-display", "none" \
#]
