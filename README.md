Nandroid backups are usually performed in recovery mode. This means you would have to turn off your phone and reboot in recovery mode, which wastes a whole lot of time rebooting and a lot more time offline. For me, this has been a killer as I do regular nandroid backups. Having to reboot in recovery and finding missed calls, sms from my wife and friends is totally not accepatable for me. So, I set to develop an online nandroid backup tool, namely Online Nandroid, which can do nandroid backups without switching off my phone.

Today I am releasing it to public, as it may serve good for some others too. Originally I developed Online Nandroid specifically for Xperia devices, but now I am releasing it for all android devices.

This tool, eventhough called "Online Nandroid", does not upload/save backups to any online/cloud services. Online here means that it does backup while phone is live or still running Android.

The short name onandroid is meant to be pronouced as o-nandroid or o'nandroid and NOT on-android.

Online Nandroid backups the below partitions to `/sdcard/clockworkmod/backup` directory.

* mmcblk0_start (for Acer devices)
* uboot (for MTK based devices)
* boot
* init_boot (Android 13+ devices, this is what Magisk patches)
* vendor_boot
* dtbo
* vbmeta
* recovery
* wimax (for Samsung devices)
* appslog (for HTC and Sony (Ericsson) devices)
* kernel
* modem
* Trim Area / TA (for Sony devices)
* system
* data
* cache
* datadata (for Samsung devices)
* data/data (for HTC devices)
* efs (for Samsung devices)
* preload (for Samsung devices)
* .cust_backup (for Huawei devices)
* flexrom (for Acer devices)
* custpack (for Alcatel devices)
* mobile_info (for Alcatel devices)
* .android_secure
* sd-ext

The date format used for folder name is the same used by CWM itself and nandroid backups created with Online Nandroid can safely be restored using CWM, TWRP and 4EXT recoveries.

Feedback (especially ideas to improve) are most welcome.

## Magisk and modern Android (10 - 15)

Online Nandroid works on current devices rooted with Magisk, KernelSU or APatch.

### Install

* **As a module (recommended):** build the zip with `scripts/build-magisk-module.sh` and flash it from the Modules tab in the Magisk / KernelSU / APatch app. Reboot, then run `su -c onandroid`.
* **Manually:** copy `onandroid` to the phone and run `su -c sh /path/to/onandroid`.

No separate busybox is needed. The busybox that comes with Magisk (`/data/adb/magisk/busybox`), KernelSU or APatch is used automatically. You can force a specific one by writing its path to `/data/local/tmp/onandroid.busybox`.

### Examples

    su -c onandroid -w          # TWRP backup (recommended on modern devices)
    su -c onandroid -w -a bnd   # only boot, init_boot and data
    su -c onandroid -w -xd      # TWRP backup without dalvik-cache

### What is different on modern devices

* Partitions are found through `/dev/block/by-name`. On A/B devices the **active slot** is backed up (`boot_a` or `boot_b`, etc.). The images are saved as `boot.emmc.win`, `init_boot.emmc.win`, and so on.
* On Android 10+ backups are written to `/data/media/0` (that is `/sdcard`), for example `/sdcard/TWRP/BACKUPS/<serial>/<date>`. TWRP finds them there. Use `-s` for an external SD card.
* `/data` is backed up without `/data/media` (your photos, downloads and other internal storage files). Copy those to a PC or another place yourself.
* If toybox has `tar --selinux` (Android 10+), it is used, so SELinux labels are stored the same way TWRP stores them.
* `/system`, `/vendor` and `/product` are read-only images inside the `super` partition and are **not** backed up. To restore them, flash the same stock ROM / OTA.
* If the script is started in an app's isolated mount namespace, it re-runs itself in the global namespace (the same as `su --mount-master`), so all of `/data` is visible.

### Restoring

Restore with TWRP (or OrangeFox) for your device. The recovery must be able to decrypt `/data`. Restore onto the same ROM version the backup was made on. You can also flash the boot images directly:

    fastboot flash init_boot init_boot.emmc.win
    fastboot flash boot boot.emmc.win
