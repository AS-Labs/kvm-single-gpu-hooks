#!/bin/bash
set -x

# Stop display manager
systemctl stop sddm.service
killall gdm-x-session waybar swaybg Hyprland xdg-desktop-portal-hyprland xdg-desktop-portal 
# rc-service xdm stop
    
# Unbind VTconsoles: might not be needed
echo 0 > /sys/class/vtconsole/vtcon0/bind
echo 0 > /sys/class/vtconsole/vtcon1/bind

# Unbind EFI Framebuffer
echo efi-framebuffer.0 > /sys/bus/platform/drivers/efi-framebuffer/unbind

sleep 2

# Unload NVIDIA kernel modules
modprobe -r nvidia_drm nvidia_modeset nvidia_uvm nvidia

# Unload AMD kernel module
# modprobe -r amdgpu

# Detach GPU devices from host
# Use your GPU and HDMI Audio PCI host device
virsh nodedev-detach pci_0000_0c_00_0
virsh nodedev-detach pci_0000_0c_00_1
virsh nodedev-detach pci_0000_0c_00_2
virsh nodedev-detach pci_0000_0c_00_3

# Load vfio module
modprobe vfio-pci
