#!/bin/bash

# DO NOT RUN THIS unless you want /dev/sda to be completely destroyed.

umount /mnt/boot
umount /mnt
swapoff -a

parted -s /dev/sda mklabel gpt

parted -s /dev/sda mkpart msdos 2048s 411647s
parted -s /dev/sda set 1 esp on
parted -s /dev/sda set 1 boot on
mkfs.fat -F32 /dev/sda1 -F

parted -s /dev/sda mkpart ext4 411648s 42354687s
mkfs.ext4 /dev/sda2 -F

parted -s /dev/sda mkpart linux-swap 42354688s 46548991s
mkswap /dev/sda3
swapon /dev/sda3

mount /dev/sda2 /mnt
mkdir -p /mnt/boot
mount /dev/sda1 /mnt/boot
rm -r /mnt/boot/*

pacstrap /mnt       \
    base            \
    base-devel      \
    grub-efi-x86_64 \
    os-prober       \
    efibootmgr      \
    wpa_supplicant  \
    wireless_tools  \
    wpa_actiond     \
    dialog          \
    git             \
    vim             \
    tmux            \
    wget            \
    alsa-utils      \
    xorg-server xorg-init xorg-server-utils \
    nvidia          \
    xorg-twm xorg-xclock xterm              \
    ttf-dejavu      \
    gnome           \
    sudo

genfstab /mnt > /mnt/etc/fstab


arch-chroot /mnt /bin/bash -c "echo LANG=en_US.UTF-8 UTF-8 > /etc/locale.conf && export LANG=en_US.UTF-8"
arch-chroot /mnt /bin/bash -c "grub-install --efi-directory=/boot && grub-mkconfig -o /boot/grub/grub.cfg"
arch-chroot /mnt /bin/bash -c "ln -s /usr/shar/zoneinfo/America/New_York /etc/localtime && hwclock --systohc --utc"

arch-chroot /mnt /bin/bash -c "systemctl enable net-auto-wireless.service"
arch-chroot /mnt /bin/bash -c "systemctl enable gdm.service"
arch-chroot /mnt /bin/bash -c "useradd -m -g users -G wheel,storage,power -s /bin/bash jfo && passwd jfo"

reboot