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
RUN ./raspi-ros-partition.sh
