# Copyright (C) 2014 The Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# TEMPORARY: These libraries are deprecated, not referenced by any AOSP
# nor OSS HAL We don't add a dependency on the vndk variants as those
# end up in /system but require these in /vendor instead:
PRODUCT_PACKAGES += \
    libhwbinder.vendor \
    libhidltransport.vendor

# Build scripts
MOTOROLA_CLEAR_VARS := $(COMMON_PATH)/motorola_clear_vars.mk
MOTOROLA_BUILD_SYMLINKS := $(COMMON_PATH)/motorola_build_symlinks.mk

DEVICE_PACKAGE_OVERLAYS += $(COMMON_PATH)/overlay

PRODUCT_ENFORCE_RRO_TARGETS := *

PRODUCT_DEXPREOPT_SPEED_APPS += SystemUI

# Platform Path
COMMON_PATH := device/motorola/sm6115-common

# Platform
BENGAL := bengal
TARGET_KERNEL_VERSION := 4.19
PRODUCT_PLATFORM_MOT := true
TARGET_BOARD_PLATFORM := $(BENGAL)
qcom_platform := sm8250

# Rootdir Path
MOTOROLA_ROOT := $(COMMON_PATH)/rootdir

# Overlay
DEVICE_PACKAGE_OVERLAYS += \
    $(COMMON_PATH)/overlay

# Camera
TARGET_USES_64BIT_CAMERA := true

# BT definitions for Qualcomm solution
BOARD_BLUETOOTH_BDROID_BUILDCFG_INCLUDE_DIR := $(COMMON_PATH)/bluetooth

# Dynamic Partitions: Enable DP
PRODUCT_USE_DYNAMIC_PARTITIONS := true

# A/B support
AB_OTA_UPDATER := true
PRODUCT_SHIPPING_API_LEVEL := 29

# A/B OTA dexopt package
PRODUCT_PACKAGES += \
    otapreopt_script

# A/B OTA dexopt update_engine hookup
AB_OTA_POSTINSTALL_CONFIG += \
    RUN_POSTINSTALL_system=true \
    POSTINSTALL_PATH_system=system/bin/otapreopt_script \
    FILESYSTEM_TYPE_system=ext4 \
    POSTINSTALL_OPTIONAL_system=true

# A/B related packages
PRODUCT_PACKAGES += \
    update_engine \
    update_engine_client \
    update_engine_sideload \
    update_verifier \
    bootctrl.sm6115-common \
    bootctrl.sm6115-common.recovery

AB_OTA_PARTITIONS += \
    boot \
    dtbo \
    product \
    system \
    vendor \
    vbmeta

# Force building a recovery image: Needed for OTA packaging to work since Q
PRODUCT_BUILD_RECOVERY_IMAGE := true

# Kernel Path
KERNEL_PATH := kernel/motorola/msm-$(TARGET_KERNEL_VERSION)

# Configure qti-headers auxiliary module via soong
SOONG_CONFIG_NAMESPACES += qti_kernel_headers
SOONG_CONFIG_qti_kernel_headers := version
SOONG_CONFIG_qti_kernel_headers_version := $(TARGET_KERNEL_VERSION)

# Codecs Configuration
PRODUCT_COPY_FILES += \
    frameworks/av/media/libstagefright/data/media_codecs_google_audio.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_google_audio.xml \
    frameworks/av/media/libstagefright/data/media_codecs_google_telephony.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_google_telephony.xml \
    frameworks/av/media/libstagefright/data/media_codecs_google_video.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_google_video.xml

# QMI
PRODUCT_COPY_FILES += \
    $(COMMON_PATH)/rootdir/vendor/etc/data/dsi_config.xml:$(TARGET_COPY_OUT_VENDOR)/etc/data/dsi_config.xml \
    $(COMMON_PATH)/rootdir/vendor/etc/data/netmgr_config.xml:$(TARGET_COPY_OUT_VENDOR)/etc/data/netmgr_config.xml

# QSEECOM TZ Storage
PRODUCT_COPY_FILES += \
    $(COMMON_PATH)/rootdir/vendor/etc/gpfspath_oem_config.xml:$(TARGET_COPY_OUT_VENDOR)/etc/gpfspath_oem_config.xml

# Sec Configuration
PRODUCT_COPY_FILES += \
    $(COMMON_PATH)/rootdir/vendor/etc/sec_config:$(TARGET_COPY_OUT_VENDOR)/etc/sec_config

# Seccomp policy
PRODUCT_COPY_FILES += \
    $(COMMON_PATH)/rootdir/vendor/etc/seccomp_policy/imsrtp.policy:$(TARGET_COPY_OUT_VENDOR)/etc/seccomp_policy/imsrtp.policy

# Audio Configuration
PRODUCT_COPY_FILES += \
    $(COMMON_PATH)/rootdir/vendor/etc/audio_effects.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_effects.xml \
    frameworks/av/services/audiopolicy/config/a2dp_in_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/a2dp_in_audio_policy_configuration.xml \
    frameworks/av/services/audiopolicy/config/bluetooth_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/bluetooth_audio_policy_configuration.xml \
    frameworks/av/services/audiopolicy/config/r_submix_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/r_submix_audio_policy_configuration.xml \
    frameworks/av/services/audiopolicy/config/usb_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/usb_audio_policy_configuration.xml

# Additional native libraries
# See https://source.android.com/devices/tech/config/namespaces_libraries
PRODUCT_COPY_FILES += \
    $(COMMON_PATH)/rootdir/vendor/etc/public.libraries.txt:$(TARGET_COPY_OUT_VENDOR)/etc/public.libraries.txt

# Depend on symlink creation in /vendor:
PRODUCT_PACKAGES += \
    tftp_symlinks

# Create firmware mount point folders in /vendor:
PRODUCT_PACKAGES += \
    firmware_folders

# Bluetooth
PRODUCT_COPY_FILES += \
    $(COMMON_PATH)/rootdir/vendor/etc/sysconfig/component-overrides.xml:$(TARGET_COPY_OUT_VENDOR)/etc/sysconfig/component-overrides.xml

# Perf
TARGET_USES_INTERACTION_BOOST := true

# Only define bootctrl HAL availability on AB platforms:
ifeq ($(AB_OTA_UPDATER),true)
PRODUCT_PACKAGES += \
    android.hardware.boot@1.1-impl-qti \
    android.hardware.boot@1.1-impl-qti.recovery \
    android.hardware.boot@1.1-service
endif

# Dynamic Partitions: build fastbootd
PRODUCT_PACKAGES += \
    fastbootd

# Treble
# Include vndk/vndk-sp/ll-ndk modules
PRODUCT_PACKAGES += \
    vndk_package

# Device Specific Permissions
PRODUCT_COPY_FILES += \
     frameworks/native/data/etc/android.hardware.sensor.gyroscope.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.gyroscope.xml \
     frameworks/native/data/etc/android.hardware.sensor.barometer.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.barometer.xml \
     frameworks/native/data/etc/android.hardware.sensor.stepcounter.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.stepcounter.xml \
     frameworks/native/data/etc/android.hardware.sensor.stepdetector.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.stepdetector.xml

# Audio
PRODUCT_PACKAGES += \
    android.hardware.audio@6.0-impl:32 \
    android.hardware.audio.service \
    android.hardware.audio.effect@6.0-impl:32 \
    android.hardware.bluetooth@1.0.vendor \
    android.hardware.bluetooth.audio-impl \
    android.hardware.soundtrigger@2.1.vendor \
    android.hardware.soundtrigger@2.2.vendor \
    android.hardware.soundtrigger@2.3.vendor \
    android.hardware.soundtrigger@2.3-impl \
    com.dsi.ant@1.0.vendor \
    com.qualcomm.qti.bluetooth_audio@1.0.vendor \
    vendor.qti.hardware.btconfigstore@1.0.vendor \
    vendor.qti.hardware.btconfigstore@2.0.vendor \
    audio.bluetooth.default \
    libtinyalsa \
    tinymix \
    libfmq

PRODUCT_COPY_FILES += \
    $(MOTOROLA_ROOT)/vendor/etc/audio_platform_info.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_platform_info.xml \
    $(MOTOROLA_ROOT)/vendor/etc/audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_configuration.xml \
    $(MOTOROLA_ROOT)/vendor/etc/audio_policy_configuration_bluetooth_legacy_hal.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_configuration_bluetooth_legacy_hal.xml \
    $(MOTOROLA_ROOT)/vendor/firmware/aw882xx_pid_1852_acf.bin:$(TARGET_COPY_OUT_VENDOR)/firmware/aw882xx_pid_1852_acf.bin \
    $(MOTOROLA_ROOT)/vendor/firmware/aw882xx_pid_2113_acf.bin:$(TARGET_COPY_OUT_VENDOR)/firmware/aw882xx_pid_2113_acf.bin

# FIXME: master: compat for libprotobuf
# See https://android-review.googlesource.com/c/platform/prebuilts/vndk/v28/+/1109518
PRODUCT_PACKAGES += \
    libprotobuf-cpp-full-vendorcompat

# Camera
PRODUCT_PACKAGES += \
    android.hardware.camera.provider@2.5 \
    android.frameworks.displayservice@1.0.vendor \
    android.frameworks.sensorservice@1.0.vendor \
    vendor.qti.hardware.camera.postproc@1.0.vendor
ifeq ($(TARGET_USES_64BIT_CAMERA),true)
PRODUCT_PACKAGES += \
    android.hardware.camera.provider@2.4-impl:64 \
    android.hardware.camera.provider@2.4-service_64
else
PRODUCT_PACKAGES += \
    android.hardware.camera.provider@2.4-impl:32 \
    android.hardware.camera.provider@2.4-service
endif

# Charger
PRODUCT_PACKAGES += \
    charger_res_images

# DRM
PRODUCT_PACKAGES += \
    android.hardware.drm@1.0-impl \
    android.hardware.drm@1.0-service-lazy \
    android.hardware.drm@1.4-service-lazy.clearkey

# The following modules are included in debuggable builds only.
PRODUCT_PACKAGES_DEBUG += \
    bootctl \
    update_engine_client

# Fingerprint
PRODUCT_PACKAGES += \
    android.hardware.biometrics.fingerprint@2.1.vendor

# FM
PRODUCT_PACKAGES += \
    vendor.qti.hardware.fm@1.0 \
    vendor.qti.hardware.fm@1.0.vendor

# For config.fs
PRODUCT_PACKAGES += \
    fs_config_files \
    fs_config_dirs

# GNSS
PRODUCT_PACKAGES += \
    android.hardware.gnss.measurement_corrections@1.0.vendor \
    android.hardware.gnss.measurement_corrections@1.1.vendor \
    android.hardware.gnss.visibility_control@1.0.vendor \
    android.hardware.gnss@1.0.vendor \
    android.hardware.gnss@1.1.vendor \
    android.hardware.gnss@2.0.vendor \
    android.hardware.gnss@2.1.vendor

# Health
PRODUCT_PACKAGES += \
    android.hardware.health@2.1-impl \
    android.hardware.health@2.1-service

# HIDL
PRODUCT_PACKAGES += \
    android.hidl.base@1.0 \
    android.hidl.base@1.0.vendor

# IMS (OSS)
PRODUCT_PACKAGES += \
    telephony-ext \
    ims-ext-common \
    ims_ext_common.xml

# Lights HAL
PRODUCT_PACKAGES += \
    android.hardware.lights-service.moto

# Linked by Adreno/EGL blobs for fallback if 3.0 doesn't exist
PRODUCT_PACKAGES += \
    vendor.qti.hardware.display.allocator@3.0.vendor \
    vendor.qti.hardware.display.mapper@2.0.vendor

# Media
PRODUCT_PACKAGES += \
    libavservices_minijail.vendor

PRODUCT_COPY_FILES += \
    $(MOTOROLA_ROOT)/vendor/etc/media_codecs.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs.xml \
    $(MOTOROLA_ROOT)/vendor/etc/media_codecs_performance.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_performance.xml \
    $(MOTOROLA_ROOT)/vendor/etc/media_profiles_V1_0.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_profiles_V1_0.xml \
    $(MOTOROLA_ROOT)/vendor/etc/media_profiles_vendor.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_profiles_vendor.xml

# MotoActions
PRODUCT_PACKAGES += \
    MotoActions

# OSS Time service
PRODUCT_PACKAGES += \
    timekeep \
    TimeKeep

# Permissions
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.audio.low_latency.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.audio.low_latency.xml \
    frameworks/native/data/etc/android.hardware.bluetooth.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.bluetooth.xml \
    frameworks/native/data/etc/android.hardware.bluetooth_le.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.bluetooth_le.xml \
    frameworks/native/data/etc/android.hardware.camera.flash-autofocus.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.flash-autofocus.xml \
    frameworks/native/data/etc/android.hardware.camera.front.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.front.xml \
    frameworks/native/data/etc/android.hardware.camera.full.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.full.xml \
    frameworks/native/data/etc/android.hardware.camera.raw.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.raw.xml \
    frameworks/native/data/etc/android.hardware.fingerprint.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.fingerprint.xml \
    frameworks/native/data/etc/android.hardware.location.gps.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.location.gps.xml \
    frameworks/native/data/etc/android.hardware.sensor.accelerometer.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.accelerometer.xml \
    frameworks/native/data/etc/android.hardware.sensor.compass.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.compass.xml \
    frameworks/native/data/etc/android.hardware.sensor.light.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.light.xml \
    frameworks/native/data/etc/android.hardware.sensor.proximity.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.proximity.xml \
    frameworks/native/data/etc/android.hardware.wifi.direct.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.direct.xml \
    frameworks/native/data/etc/android.hardware.wifi.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.xml \
    frameworks/native/data/etc/android.software.sip.voip.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.sip.voip.xml \
    frameworks/native/data/etc/android.hardware.usb.accessory.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.usb.accessory.xml \
    frameworks/native/data/etc/android.hardware.usb.host.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.usb.host.xml \
    frameworks/native/data/etc/android.software.verified_boot.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.verified_boot.xml

# QCOM Data
PRODUCT_PACKAGES += \
    librmnetctl

# QTI Haptics Vibrator
PRODUCT_PACKAGES += \
    vendor.qti.hardware.vibrator.service

# Qualcom WiFi Overlay
PRODUCT_COPY_FILES += \
    $(MOTOROLA_ROOT)/vendor/etc/wifi/wpa_supplicant_overlay.conf:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/wpa_supplicant_overlay.conf \
    $(MOTOROLA_ROOT)/vendor/etc/wifi/p2p_supplicant_overlay.conf:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/p2p_supplicant_overlay.conf

# Qualcom WiFi Configuration
PRODUCT_COPY_FILES += \
    $(MOTOROLA_ROOT)/vendor/firmware/wlan/qca_cld/WCNSS_qcom_cfg.ini:$(TARGET_COPY_OUT_VENDOR)/firmware/wlan/qca_cld/WCNSS_qcom_cfg.ini

# MSM IRQ Balancer configuration file
PRODUCT_COPY_FILES += \
    $(MOTOROLA_ROOT)/vendor/etc/msm_irqbalance.conf:$(TARGET_COPY_OUT_VENDOR)/etc/msm_irqbalance.conf

# Platform specific init
PRODUCT_PACKAGES += \
    ueventd

# Power
ifeq ($(BOARD_USES_PIXEL_POWER_HAL),true)
PRODUCT_PACKAGES += \
    libperfmgr.vendor
endif

ifeq ($(PRODUCT_USES_PIXEL_POWER_HAL),true)
PRODUCT_PACKAGES += \
    android.hardware.power-service.moto-common-libperfmgr
else
$(call inherit-product, vendor/qcom/opensource/power/power-vendor-product.mk)
endif

PRODUCT_PACKAGES += \
    android.hardware.power@1.0.vendor \
    android.hardware.power@1.1.vendor \
    android.hardware.power@1.2.vendor

# RIL
PRODUCT_PACKAGES += \
    android.hardware.radio@1.2.vendor \
    android.hardware.radio@1.3.vendor \
    android.hardware.radio@1.4.vendor \
    android.hardware.radio@1.5.vendor \
    android.hardware.radio.config@1.0.vendor \
    android.hardware.radio.config@1.1.vendor \
    android.hardware.radio.config@1.2.vendor \
    android.hardware.radio.deprecated@1.0.vendor \
    android.hardware.secure_element@1.2.vendor \
    android.system.net.netd@1.1.vendor \
    disable_configstore \
    ims-moto-libs \
    libandroid_net \
    libjson \
    libprotobuf-cpp-full \
    libqsap_sdk \
    libsensorndkbridge \
    qti-telephony-hidl-wrapper \
    qti-telephony-hidl-wrapper-prd \
    qti_telephony_hidl_wrapper.xml \
    qti_telephony_hidl_wrapper_prd.xml \
    qti-telephony-utils \
    qti_telephony_utils.xml

# Sensors
# hardware.ssc.so links against display mappers, of which
# the interface libraries are explicitly included here:
PRODUCT_PACKAGES += \
    android.hardware.sensors@2.0-service.multihal \
    vendor.qti.hardware.display.mapper@1.1.vendor \
    vendor.qti.hardware.display.mapper@3.0.vendor

# Telephony
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/handheld_core_hardware.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/handheld_core_hardware.xml \
    frameworks/native/data/etc/android.hardware.telephony.gsm.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.telephony.gsm.xml \
    frameworks/native/data/etc/android.hardware.telephony.ims.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.telephony.ims.xml

# Telephony: IMS framework
PRODUCT_COPY_FILES += \
    $(COMMON_PATH)/rootdir/system/system_ext/etc/permissions/privapp-permissions-ims.xml:$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/permissions/privapp-permissions-ims.xml

# Thermal HAL
PRODUCT_SOONG_NAMESPACES += \
    vendor/qcom/opensource/thermal

PRODUCT_PACKAGES += \
    android.hardware.thermal@2.0-service.qti

# QCOM Bluetooth
PRODUCT_PROPERTY_OVERRIDES += \
    persist.vendor.qcom.bluetooth.soc=cherokee

# Legacy BT property (will be removed in S)
PRODUCT_PROPERTY_OVERRIDES += \
    vendor.qcom.bluetooth.soc=cherokee

# Gatekeeper
PRODUCT_PROPERTY_OVERRIDES += \
    vendor.gatekeeper.disable_spu=true

# Common init scripts
PRODUCT_PACKAGES += \
    init.class_main.sh \
    init.gadgethal.sh \
    init.mmi.charge_only.rc \
    init.mmi.chipset.rc \
    init.mmi.overlay.rc \
    init.mmi.touch.sh \
    init.mmi.rc \
    init.oem.fingerprint2.sh \
    init.oem.hw.sh \
    init.qcom.ipastart.sh \
    init.qcom.rc \
    init.qti.kernel.rc \
    init.qti.kernel.sh \
    init.qti.qcv.rc \
    init.qti.qcv.sh \
    init.recovery.qcom.rc \
    init.target.rc \
    init.usb.rc \
    vendor_modprobe.sh

ifeq ($(TARGET_USES_FPC_FINGERPRINT),true)
PRODUCT_COPY_FILES += \
    $(COMMON_PATH)/rootdir/vendor/etc/init/android.hardware.biometrics.fingerprint@2.1-service-fpc2.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/android.hardware.biometrics.fingerprint@2.1-service-fpc2.rc
endif

ifeq ($(TARGET_USES_CHIPONE_FINGERPRINT),true)
PRODUCT_COPY_FILES += \
    $(COMMON_PATH)/rootdir/vendor/etc/init/android.hardware.biometrics.fingerprint@2.1-service-chipone2.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/android.hardware.biometrics.fingerprint@2.1-service-chipone2.rc
endif

ifeq ($(TARGET_USES_GOODIX_FINGERPRINT),true)
PRODUCT_COPY_FILES += \
    $(COMMON_PATH)/rootdir/vendor/etc/init/android.hardware.biometrics.fingerprint@2.1-goodixservice.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/android.hardware.biometrics.fingerprint@2.1-goodixservice.rc
endif

ifeq ($(TARGET_USES_EGISTEC_FINGERPRINT),true)
PRODUCT_COPY_FILES += \
    $(COMMON_PATH)/rootdir/vendor/etc/init/android.hardware.biometrics.fingerprint@2.1-service-ets2.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/android.hardware.biometrics.fingerprint@2.1-service-ets2.rc
endif

PRODUCT_COPY_FILES += \
    device/qcom/common/vendor/init/bengal/bin/init.kernel.post_boot.sh:$(TARGET_COPY_OUT_VENDOR)/bin/init.kernel.post_boot.sh

PRODUCT_SOONG_NAMESPACES += device/qcom/common/vendor/init

# FPSensor Gestures
PRODUCT_COPY_FILES += \
    $(MOTOROLA_ROOT)/vendor/usr/keylayout/uinput-fpc.kl:$(TARGET_COPY_OUT_VENDOR)/usr/keylayout/uinput-fpc.kl \
    $(MOTOROLA_ROOT)/vendor/usr/idc/uinput-fpc.idc:$(TARGET_COPY_OUT_VENDOR)/usr/idc/uinput-fpc.idc

# Fingerprint
TARGET_USES_FPC_FINGERPRINT := true

# Power
PRODUCT_COPY_FILES += \
    $(MOTOROLA_ROOT)/vendor/etc/powerhint.json:$(TARGET_COPY_OUT_VENDOR)/etc/powerhint.json

PRODUCT_USES_PIXEL_POWER_HAL := true

# USB
PRODUCT_USES_PIXEL_USB_HAL := true

PRODUCT_PACKAGES += \
    android.hardware.usb@1.3-service.moto-common

# Telephony
PRODUCT_PROPERTY_OVERRIDES += \
    ro.telephony.default_network=10,10

# Force using the following regardless of shipping API level:
#   PRODUCT_TREBLE_LINKER_NAMESPACES
#   PRODUCT_SEPOLICY_SPLIT
#   PRODUCT_ENFORCE_VINTF_MANIFEST
#   PRODUCT_NOTICE_SPLIT
PRODUCT_FULL_TREBLE_OVERRIDE := true

# VNDK
# Force using VNDK regardless of shipping API level
PRODUCT_USE_VNDK_OVERRIDE := true
# Include vndk/vndk-sp/ll-ndk modules
PRODUCT_PACKAGES += \
    vndk_package

# Enable building packages from device namespaces.
# Might be temporary! See:
# https://android.googlesource.com/platform/build/soong/+/master/README.md#name-resolution
PRODUCT_SOONG_NAMESPACES += \
    $(COMMON_PATH) \
    vendor/qcom/opensource/audio/$(qcom_platform) \
    vendor/qcom/opensource/data-ipa-cfg-mgr \
    vendor/qcom/opensource/display/$(qcom_platform) \
    vendor/qcom/opensource/display-commonsys-intf

# Enable pixel soong namespace for Pixel USB and Power HAL
PRODUCT_SOONG_NAMESPACES += \
    hardware/google/pixel

$(call inherit-product, device/motorola/sm6115-common/props.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/updatable_apex.mk)

# Proprietary Blobs
QCOM_COMMON_PATH := device/qcom/common
# System
include $(QCOM_COMMON_PATH)/system/audio/qti-audio.mk
include $(QCOM_COMMON_PATH)/system/av/qti-av.mk
include $(QCOM_COMMON_PATH)/system/display/qti-display.mk
include $(QCOM_COMMON_PATH)/system/overlay/qti-overlay.mk
ifneq ($(PRODUCT_USES_PIXEL_POWER_HAL),true)
include $(QCOM_COMMON_PATH)/system/perf/qti-perf.mk
endif
# Vendor
include $(QCOM_COMMON_PATH)/vendor/adreno/qti-adreno.mk
include $(QCOM_COMMON_PATH)/vendor/audio/qti-audio.mk
include $(QCOM_COMMON_PATH)/vendor/display/$(TARGET_KERNEL_VERSION)/qti-display.mk
include $(QCOM_COMMON_PATH)/vendor/charging/qti-charging.mk
include $(QCOM_COMMON_PATH)/vendor/drm/qti-drm.mk
include $(QCOM_COMMON_PATH)/vendor/dsprpcd/qti-dsprpcd.mk
include $(QCOM_COMMON_PATH)/vendor/keymaster/qti-keymaster.mk
ifeq ($(TARGET_KERNEL_VERSION),5.4)
include $(QCOM_COMMON_PATH)/vendor/media/qti-media.mk
else
include $(QCOM_COMMON_PATH)/vendor/media-legacy/qti-media-legacy.mk
endif
ifneq ($(PRODUCT_USES_PIXEL_POWER_HAL),true)
include $(QCOM_COMMON_PATH)/vendor/perf/qti-perf.mk
endif
ifneq ($(TARGET_KERNEL_VERSION),5.4)
include $(QCOM_COMMON_PATH)/vendor/qseecomd-legacy/qti-qseecomd-legacy.mk
else
include $(QCOM_COMMON_PATH)/vendor/qseecomd/qti-qseecomd.mk
endif
include $(QCOM_COMMON_PATH)/vendor/wlan/qti-wlan.mk

PRODUCT_SOONG_NAMESPACES += \
    vendor/qcom/common/vendor/dsprpcd \
    vendor/qcom/common/vendor/perf
