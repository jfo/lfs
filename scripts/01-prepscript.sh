#!/bin/bash

# DO NOT RUN THIS unless you want /dev/sda to be completely destroyed.

wifi-menu

umount /mnt/boot
umount /mnt
swapoff -a

parted -s /dev/sda mklabel gpt

parted -s /dev/sda mkpart msdos 2048s 411647s
parted -s /dev/sda set 1 esp on
parted -s /dev/sda set 1 boot on
mkfs.fat -F32 /dev/sda1 -F

parted -s /dev/sda mkpart ext4 411648s 21383167s
mkfs.ext4 /dev/sda2 -F

parted -s /dev/sda mkpart ext4 21383168s 42354687s
mkfs.ext4 /dev/sda3 -F

parted -s /dev/sda mkpart linux-swap 42354688s 46548991s
mkswap /dev/sda4
swapon /dev/sda4

mount /dev/sda3 /mnt
mkdir -p /mnt/boot
mount /dev/sda1 /mnt/boot
rm -r /mnt/boot/*

pacstrap /mnt       \
    base            \
    base-devel      \
    grub-efi-x86_64 \
    efibootmgr      \
    wpa_supplicant  \
    dialog          \
    git             \
    vim             \
    tmux	    \
    wget

genfstab /mnt > /mnt/etc/fstab

arch-chroot /mnt /bin/bash -c 'echo "en_US.UTF-8 UTF_8" >> /etc/locale.gen && locale-gen'
arch-chroot /mnt /bin/bash -c "grub-install --efi-directory=/boot && grub-mkconfig -o /boot/grub/grub.cfg"

# reboot
