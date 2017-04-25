include hardware/nvidia/tegra3/BoardConfigCommon.mk

TARGET_NO_BOOTLOADER := true
TARGET_BOOTLOADER_BOARD_NAME := picasso
TARGET_OTA_ASSERT_DEVICE := picasso2,a510,a700,picasso_m,picasso_mf,a510_emea_cus1,a700_emea_cus1

BOARD_KERNEL_CMDLINE := androidboot.hardware=picasso androidboot.selinux=permissive
BOARD_KERNEL_BASE := 0x10000000
BOARD_KERNEL_PAGESIZE := 2048

TARGET_USERIMAGES_USE_EXT4 := true
TARGET_USERIMAGES_USE_F2FS := true

BOARD_BOOTIMAGE_PARTITION_SIZE := 8388608
BOARD_RECOVERYIMAGE_PARTITION_SIZE := 6291456
BOARD_SYSTEMIMAGE_PARTITION_SIZE := 1283457024
BOARD_CACHEIMAGE_PARTITION_SIZE := 367001600
BOARD_USERDATAIMAGE_PARTITION_SIZE := 29813112832
BOARD_FLASH_BLOCK_SIZE := 4096

# Configure jemalloc for low-memory
MALLOC_SVELTE := true

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

TARGET_KERNEL_SOURCE := kernel/nvidia/tegra3
TARGET_KERNEL_CONFIG := picasso_defconfig

BOARD_USES_GENERIC_INVENSENSE := false

TARGET_NEEDS_PLATFORM_TEXTRELS := true

-include vendor/acer/t30-common/BoardConfigVendor.mk

# Bluetooth
BOARD_HAVE_BLUETOOTH := true
BOARD_HAVE_BLUETOOTH_BCM := true
BOARD_BLUETOOTH_BDROID_BUILDCFG_INCLUDE_DIR := device/acer/picasso2/bluetooth

# Selinux
BOARD_SEPOLICY_DIRS += \
	device/acer/picasso2/sepolicy

# Recovery
LZMA_RAMDISK_TARGETS := recovery
TARGET_NOT_USE_GZIP_RECOVERY_RAMDISK := true
TARGET_RECOVERY_FSTAB := device/acer/picasso2/rootdir/fstab.picasso
BOARD_HAS_NO_SELECT_BUTTON := true
