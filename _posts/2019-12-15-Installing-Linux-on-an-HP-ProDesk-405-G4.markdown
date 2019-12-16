---
layout: post
title: Installing Linux on an HP ProDesk 405 G4
date: 2019-12-15
---

<table>
<tr><td>CPU/GPU</td><td>AMD Ryzen 5 Quad-core with Radeon Vega 11 graphics</td></tr>
<tr><td>Memory</td><td>8GB</td></tr>
<tr><td>Storage</td><td>256GB SSD</td></tr>
<tr><td>Wireless</td><td>Intel wireless</td></tr>
</table>

* I updated the BIOS (over the network) from 2.02 to 2.09. Initially the BIOS interface refused to connect to the network over ethernet -- reverting the BIOS config to the factory settings fixed this.

* The initial Linux install was bumpy. I installed the `amdgpu` drivers, installed the firmware, and disabled modesetting. But on boot, the `amdgpu` drivers would hang the kernel. Checking the `/var/log/dmesg.0` file revealed an error: "Unable to locate BIOS ROM." The cause of the error was using Legacy BIOS. Disabling that and booting through UEFI enabled the `amdgpu` drivers to run.

* There were still graphical artifacts on the system, though. There were two fixes I had to apply:

  * The [first one fixed](https://bugs.launchpad.net/ubuntu/+source/xserver-xorg-video-amdgpu/+bug/1848741) the more general artifacts I saw (ones that spanned the whole monitor at seemingly random intervals). The fix included putting `amd_iommu=on iommu=pt` in the GRUB config. 

  * The [second one](https://forum.manjaro.org/t/solved-xfce-compositor-transparency-graphic-artifacts/98936/11) fixed XFCE. There were artifacts around window borders/text input when the compositor was enabled. The fix involved changing the `vblank_mode` to `xpresent` for XFCE (apparently it's related to some bug in glx that only affects `amdgpu` devices?)

	```
	xfconf-query -c xfwm4 -p /general/vblank_mode -t string -s "xpresent" --create
	```

* Also had to install `iwlwifi-firmware` to enable the wireless card.

I've got it running Devaun ceres (unstable), using BTRFS for the root/home filesystems. I'm expecting the performance to be similar (or slightly worse for certain workloads) than my previous custom PC build (which had an AMD FX-8320 and an NVidia GTX960), but I'm hoping that it'll be less noisy and a little more convenient to use.
