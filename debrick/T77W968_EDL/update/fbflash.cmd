rem adb reboot bootloader
fastboot devices
fastboot flash vendor vendor.img
fastboot flash sbl sbl1.mbn
fastboot flash tz tz.mbn
fastboot flash rpm rpm.mbn
fastboot flash aboot appsboot.mbn
fastboot flash boot sdx20-boot.img
fastboot erase system
fastboot flash system sdx20-sysfs.ubi
fastboot erase modem
fastboot flash modem NON-HLOS.ubi
fastboot reboot


