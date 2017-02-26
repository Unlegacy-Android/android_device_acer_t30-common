# This needs to come before the common nvidia vendor inclusion
$(call inherit-product-if-exists, vendor/acer/picasso/acer-vendor.mk)

$(call inherit-product, hardware/nvidia/tegra3/tegra3.mk)

# The gps config appropriate for this device
$(call inherit-product, device/common/gps/gps_us_supl.mk)

PRODUCT_AAPT_CONFIG := normal large xlarge hdpi
PRODUCT_AAPT_PREF_CONFIG := xlarge hdpi

DEVICE_PACKAGE_OVERLAYS += device/acer/picasso2/overlay

PRODUCT_PROPERTY_OVERRIDES := \
    nvidia.hwc.mirror_mode=crop \
    wifi.interface=wlan0 \
    ro.carrier=wifi-only

# Set default USB interface
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += \
	persist.sys.usb.config=mtp,adb

PRODUCT_PROPERTY_OVERRIDES += \
    dalvik.vm.heapstartsize=8m \
    dalvik.vm.heapgrowthlimit=96m \
    dalvik.vm.heapsize=384m \
    dalvik.vm.heaptargetutilization=0.75 \
    dalvik.vm.heapminfree=2m \
    dalvik.vm.heapmaxfree=8m

PRODUCT_COPY_FILES += \
    device/acer/picasso2/rootdir/init.picasso.rc:root/init.picasso.rc \
    device/acer/picasso2/rootdir/fstab.picasso:root/fstab.picasso \
    device/acer/picasso2/rootdir/ueventd.picasso.rc:root/ueventd.picasso.rc \
    device/acer/picasso2/rootdir/init.picasso.usb.rc:root/init.picasso.usb.rc

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/tablet_core_hardware.xml:system/etc/permissions/tablet_core_hardware.xml \
    frameworks/native/data/etc/android.hardware.location.gps.xml:system/etc/permissions/android.hardware.location.gps.xml \
    frameworks/native/data/etc/android.hardware.wifi.xml:system/etc/permissions/android.hardware.wifi.xml \
    frameworks/native/data/etc/android.hardware.wifi.direct.xml:system/etc/permissions/android.hardware.wifi.direct.xml \
    frameworks/native/data/etc/android.hardware.sensor.light.xml:system/etc/permissions/android.hardware.sensor.light.xml \
    frameworks/native/data/etc/android.hardware.sensor.gyroscope.xml:system/etc/permissions/android.hardware.sensor.gyroscope.xml \
    frameworks/native/data/etc/android.hardware.camera.autofocus.xml:system/etc/permissions/android.hardware.camera.autofocus.xml \
    frameworks/native/data/etc/android.hardware.camera.front.xml:system/etc/permissions/android.hardware.camera.front.xml \
    frameworks/native/data/etc/android.hardware.touchscreen.multitouch.jazzhand.xml:system/etc/permissions/android.hardware.touchscreen.multitouch.jazzhand.xml \
    frameworks/native/data/etc/android.software.sip.voip.xml:system/etc/permissions/android.software.sip.voip.xml \
    frameworks/native/data/etc/android.hardware.usb.host.xml:system/etc/permissions/android.hardware.usb.host.xml \
    frameworks/native/data/etc/android.hardware.usb.accessory.xml:system/etc/permissions/android.hardware.usb.accessory.xml

PRODUCT_COPY_FILES += \
    device/acer/picasso2/camera/nvcamera.conf:system/etc/nvcamera.conf \
    device/acer/picasso2/gps/gpsconfig.xml:system/etc/gps/gpsconfig.xml \
    device/acer/picasso2/ppp/ip-up:system/etc/ppp/ip-up \
    device/acer/picasso2/ppp/ip-down:system/etc/ppp/ip-down \
    device/acer/picasso2/touchscreen/atmel-maxtouch.idc:system/usr/idc/atmel-maxtouch.idc \
    device/acer/picasso2/keylayouts/Acer-AK00LB.kl:system/usr/keylayout/Acer-AK00LB.kl \
    device/acer/picasso2/keylayouts/Acer-ICONIA-TAB-KB01.kl:system/usr/keylayout/Acer-ICONIA-TAB-KB01.kl \
    device/acer/picasso2/keylayouts/acer-dock.kl:system/usr/keylayout/acer-dock.kl \
    device/acer/picasso2/keylayouts/gpio-keys.kl:system/usr/keylayout/gpio-keys.kl

# Bluetooth
PRODUCT_COPY_FILES += \
    device/acer/picasso2/bluetooth/bt_vendor.conf:system/etc/bluetooth/bt_vendor.conf

PRODUCT_PACKAGES += \
    audio.primary.tegra3 \
    audio.a2dp.default \
    audio.usb.default \
    a1026_init \
    setup_fs \
    com.android.future.usb.accessory

# Live wallpaper packages
PRODUCT_PACKAGES += \
    LiveWallpapers \
    LiveWallpapersPicker \
    MagicSmokeWallpapers \
    VisualizationWallpapers

# Publish that we support the live wallpaper feature.
PRODUCT_COPY_FILES += \
    packages/wallpapers/LivePicker/android.software.live_wallpaper.xml:/system/etc/permissions/android.software.live_wallpaper.xml

PRODUCT_CHARACTERISTICS := tablet

# Audio config
PRODUCT_COPY_FILES += \
    device/acer/picasso2/audio/tiny_hw.xml:system/etc/tiny_hw.xml \
    device/acer/picasso2/audio/audio_policy.conf:system/etc/audio_policy.conf

# Media
PRODUCT_COPY_FILES += \
    device/acer/picasso2/media/media_profiles.xml:system/etc/media_profiles.xml \
    device/acer/picasso2/media/media_codecs.xml:system/etc/media_codecs.xml

WIFI_BAND := 802_11_BG

$(call inherit-product-if-exists, hardware/broadcom/wlan/bcmdhd/firmware/bcm4330/device-bcm.mk)

$(call inherit-product-if-exists, vendor/broadcom/picasso/broadcom-vendor.mk)
$(call inherit-product-if-exists, vendor/invensense/picasso/invensense-vendor.mk)
