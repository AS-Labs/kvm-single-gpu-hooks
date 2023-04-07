#!/bin/bash
set -x

# Attach GPU devices to host
# Use your GPU and HDMI Audio PCI host device
virsh nodedev-reattach pci_0000_0c_00_3
virsh nodedev-reattach pci_0000_0c_00_2
virsh nodedev-reattach pci_0000_0c_00_1
virsh nodedev-reattach pci_0000_0c_00_0

# Unload vfio module
modprobe -r vfio-pci

# Load AMD kernel module
#modprobe amdgpu

# Rebind framebuffer to host
echo "efi-framebuffer.0" > /sys/bus/platform/drivers/efi-framebuffer/bind

sleep 2

# Load NVIDIA kernel modules
modprobe nvidia_drm
modprobe nvidia_modeset
modprobe nvidia_uvm
modprobe nvidia

# Bind VTconsoles: might not be needed
echo 1 > /sys/class/vtconsole/vtcon0/bind
#echo 1 > /sys/class/vtconsole/vtcon1/bind

# Restart Display Manager
systemctl start sddm.service
gdm-x-session
xdg-desktop-portal-hyprland
xdg-desktop-portal
waybar
swaybg
Hyprland
# rc-service xdm start
