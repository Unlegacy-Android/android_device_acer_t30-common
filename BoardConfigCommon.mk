include hardware/nvidia/tegra3/BoardConfigCommon.mk

TARGET_NO_BOOTLOADER := true

BOARD_KERNEL_CMDLINE := androidboot.hardware=picasso
BOARD_KERNEL_BASE := 0x10000000
BOARD_KERNEL_PAGESIZE := 2048

TARGET_USERIMAGES_USE_EXT4 := true

BOARD_BOOTIMAGE_PARTITION_SIZE := 8388608
BOARD_RECOVERYIMAGE_PARTITION_SIZE := 6291456
BOARD_SYSTEMIMAGE_PARTITION_SIZE := 629145600
BOARD_CACHEIMAGE_PARTITION_SIZE := 1283457024
BOARD_USERDATAIMAGE_PARTITION_SIZE := 29905387520
BOARD_FLASH_BLOCK_SIZE := 4096

# Wifi related defines
BOARD_WPA_SUPPLICANT_DRIVER := NL80211
WPA_SUPPLICANT_VERSION      := VER_0_8_X
BOARD_WPA_SUPPLICANT_PRIVATE_LIB := lib_driver_cmd_bcmdhd
BOARD_HOSTAPD_DRIVER        := NL80211
BOARD_HOSTAPD_PRIVATE_LIB   := lib_driver_cmd_bcmdhd
BOARD_WLAN_DEVICE           := bcmdhd
WIFI_DRIVER_FW_PATH_PARAM   := "/sys/module/bcmdhd/parameters/firmware_path"
WIFI_DRIVER_FW_PATH_STA     := "/vendor/firmware/fw_bcmdhd.bin"
WIFI_DRIVER_FW_PATH_AP      := "/vendor/firmware/fw_bcmdhd_apsta.bin"

TARGET_KERNEL_SOURCE := kernel/acer/t30

BOARD_USES_GENERIC_INVENSENSE := false

-include vendor/acer/t30-common/BoardConfigVendor.mk

# Bluetooth
BOARD_HAVE_BLUETOOTH := true
BOARD_HAVE_BLUETOOTH_BCM := true

# Selinux
BOARD_SEPOLICY_DIRS += \
	device/acer/t30-common/sepolicy

# Recovery
TARGET_RECOVERY_FSTAB := device/acer/t30-common/rootdir/fstab.picasso
BOARD_HAS_NO_SELECT_BUTTON := true
