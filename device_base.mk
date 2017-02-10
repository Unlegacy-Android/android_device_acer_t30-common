# The gps config appropriate for this device
$(call inherit-product, device/common/gps/gps_us_supl.mk)

PRODUCT_AAPT_CONFIG := normal large xlarge hdpi
PRODUCT_AAPT_PREF_CONFIG := xlarge hdpi

DEVICE_PACKAGE_OVERLAYS += device/acer/t30-common/overlay

PRODUCT_PROPERTY_OVERRIDES := \
    ro.opengles.version=131072 \
    sys.max_texture_size=2048 \
    persist.tegra.nvmmlite=1 \
    nvidia.hwc.mirror_mode=crop \
    tf.enable=y \
    wifi.interface=wlan0 \
    ro.carrier=wifi-only \
    ro.zygote.disable_gl_preload=true

PRODUCT_PROPERTY_OVERRIDES += \
    dalvik.vm.heapstartsize=8m \
    dalvik.vm.heapgrowthlimit=96m \
    dalvik.vm.heapsize=384m \
    dalvik.vm.heaptargetutilization=0.75 \
    dalvik.vm.heapminfree=2m \
    dalvik.vm.heapmaxfree=8m

# we have enough storage space to hold precise GC data
PRODUCT_TAGS += dalvik.gc.type-precise

PRODUCT_COPY_FILES += \
    device/acer/t30-common/rootdir/init.picasso.rc:root/init.picasso.rc \
    device/acer/t30-common/rootdir/fstab.picasso:root/fstab.picasso \
    device/acer/t30-common/rootdir/ueventd.picasso.rc:root/ueventd.picasso.rc

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/tablet_core_hardware.xml:system/etc/permissions/tablet_core_hardware.xml \
    frameworks/native/data/etc/android.hardware.bluetooth_le.xml:system/etc/permissions/android.hardware.bluetooth_le.xml \
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
    device/acer/t30-common/camera/nvcamera.conf:system/etc/nvcamera.conf \
    device/acer/t30-common/gps/gpsconfig.xml:system/etc/gps/gpsconfig.xml \
    device/acer/t30-common/ppp/ip-up:system/etc/ppp/ip-up \
    device/acer/t30-common/ppp/ip-down:system/etc/ppp/ip-down \
    device/acer/t30-common/touchscreen/atmel-maxtouch.idc:system/usr/idc/atmel-maxtouch.idc \
    device/acer/t30-common/keylayouts/Acer-AK00LB.kl:system/usr/keylayout/Acer-AK00LB.kl \
    device/acer/t30-common/keylayouts/Acer-ICONIA-TAB-KB01.kl:system/usr/keylayout/Acer-ICONIA-TAB-KB01.kl \
    device/acer/t30-common/keylayouts/acer-dock.kl:system/usr/keylayout/acer-dock.kl \
    device/acer/t30-common/keylayouts/gpio-keys.kl:system/usr/keylayout/gpio-keys.kl

# GPS
PRODUCT_PACKAGES += \
    libgpsd-compat \
    libstlport

# Bluetooth
PRODUCT_COPY_FILES += \
    device/acer/t30-common/bluetooth/bt_vendor.conf:system/etc/bluetooth/bt_vendor.conf

PRODUCT_PACKAGES += \
    audio.primary.tegra3 \
    audio.a2dp.default \
    audio.usb.default \
    a1026_init \
    setup_fs \
    com.android.future.usb.accessory

# Wi-Fi
PRODUCT_PACKAGES += \
    libwpa_client \
    hostapd \
    dhcpcd.conf \
    wpa_supplicant \
    wpa_supplicant.conf

PRODUCT_CHARACTERISTICS := tablet

# Audio config
PRODUCT_COPY_FILES += \
    device/acer/t30-common/audio/tiny_hw.xml:system/etc/tiny_hw.xml \
    device/acer/t30-common/audio/audio_policy.conf:system/etc/audio_policy.conf

# Media
PRODUCT_COPY_FILES += \
    frameworks/av/media/libstagefright/data/media_codecs_google_audio.xml:system/etc/media_codecs_google_audio.xml \
    frameworks/av/media/libstagefright/data/media_codecs_google_telephony.xml:system/etc/media_codecs_google_telephony.xml \
    frameworks/av/media/libstagefright/data/media_codecs_google_video.xml:system/etc/media_codecs_google_video.xml \
    device/acer/t30-common/media/media_profiles.xml:system/etc/media_profiles.xml \
    device/acer/t30-common/media/media_codecs.xml:system/etc/media_codecs.xml

PRODUCT_PACKAGES += \
    libstagefrighthw

WIFI_BAND := 802_11_BG

$(call inherit-product-if-exists, hardware/broadcom/wlan/bcmdhd/firmware/bcm4330/device-bcm.mk)

$(call inherit-product-if-exists, vendor/acer/picasso/acer-vendor.mk)
$(call inherit-product-if-exists, vendor/broadcom/picasso/broadcom-vendor.mk)
$(call inherit-product-if-exists, vendor/invensense/picasso/invensense-vendor.mk)
$(call inherit-product-if-exists, vendor/nvidia/tegra3/nvidia-vendor.mk)
$(call inherit-product-if-exists, vendor/widevine/arm-generic/widevine-vendor.mk)
