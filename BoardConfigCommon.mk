# Copyright 2014 The Android Open Source Project
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

# Arch
TARGET_ARCH := arm64
TARGET_CPU_ABI := arm64-v8a
TARGET_CPU_ABI2 :=
TARGET_CPU_VARIANT := generic

TARGET_2ND_ARCH := arm
TARGET_2ND_CPU_ABI := armeabi-v7a
TARGET_2ND_CPU_ABI2 := armeabi
TARGET_2ND_CPU_VARIANT := generic

TARGET_SUPPORTS_64_BIT_APPS := true

TARGET_ARCH_VARIANT := armv8-a
TARGET_CPU_ABI := arm64-v8a
TARGET_2ND_ARCH_VARIANT := armv8-a

# Bootloader
TARGET_BOOTLOADER_BOARD_NAME ?= $(PRODUCT_DEVICE)

# Charger
BOARD_CHARGER_DISABLE_INIT_BLANK := true
BOARD_CHARGER_ENABLE_SUSPEND := true

# Enable dex-preoptimization to speed up first boot sequence
WITH_DEXPREOPT := true

# Filesystem
TARGET_FS_CONFIG_GEN += $(COMMON_PATH)/mot_aids.fs

# Fixes
BUILD_BROKEN_ELF_PREBUILT_PRODUCT_COPY_FILES := true

# Kernel
BOARD_KERNEL_BASE        := 0x00000000
BOARD_KERNEL_PAGESIZE    := 4096
BOARD_RAMDISK_OFFSET     := 0x01000000
BOARD_DTB_OFFSET         := 0x01f00000
BOARD_MKBOOTIMG_ARGS += --dtb_offset $(BOARD_DTB_OFFSET)
TARGET_RECOVERY_FSTAB ?= $(PLATFORM_COMMON_PATH)/rootdir/vendor/etc/fstab.qcom
BOARD_KERNEL_CMDLINE += androidboot.usbcontroller=4e00000.dwc3
ifneq ($(BOARD_USE_ENFORCING_SELINUX),true)
BOARD_KERNEL_CMDLINE += androidboot.selinux=permissive
endif
BOARD_KERNEL_CMDLINE += androidboot.console=ttyMSM0
BOARD_KERNEL_CMDLINE += androidboot.memcg=1
BOARD_KERNEL_CMDLINE += androidboot.hardware=qcom
BOARD_KERNEL_CMDLINE += loop.max_part=7
BOARD_KERNEL_CMDLINE += service_locator.enable=1
BOARD_KERNEL_CMDLINE += swiotlb=0
BOARD_KERNEL_CMDLINE += cgroup.memory=nokmem,nosocket
BOARD_MKBOOTIMG_ARGS := --ramdisk_offset $(BOARD_RAMDISK_OFFSET) --header_version $(BOARD_BOOT_HEADER_VERSION)
TARGET_KERNEL_SOURCE := kernel/motorola/msm-4.19
BOARD_BOOT_HEADER_VERSION ?= 2
BOARD_INCLUDE_DTB_IN_BOOTIMG := true
BOARD_INCLUDE_RECOVERY_DTBO := true
BOARD_KERNEL_IMAGE_NAME := Image.gz-dtb
BOARD_PREBUILT_DTBIMAGE_DIR ?= device/motorola/$(PRODUCT_DEVICE)-kernel/dtbs
BOARD_PREBUILT_DTBOIMAGE ?= device/motorola/$(PRODUCT_DEVICE)-kernel/dtbo.img

# manifest
DEVICE_MANIFEST_FILE += $(COMMON_PATH)/vintf/manifest.xml
DEVICE_FRAMEWORK_COMPATIBILITY_MATRIX_FILE += $(COMMON_PATH)/vintf/framework_compatibility_matrix.xml
DEVICE_MATRIX_FILE += $(COMMON_PATH)/vintf/compatibility_matrix.xml
ifneq ($(TARGET_USES_FINGERPRINT_V2_1),false)
DEVICE_MANIFEST_FILE += $(COMMON_PATH)/vintf/android.hardware.biometrics.fingerprint_v2.1.xml
endif

# Media
TARGET_USES_ION := true

# Memory
MALLOC_SVELTE := true

# QCOM
TARGET_USES_HARDWARE_QCOM_GPS := false

# RIL
ENABLE_VENDOR_RIL_SERVICE := true

# SELinux
include device/qcom/sepolicy_vndr/SEPolicy.mk
include device/sony/sepolicy/sepolicy.mk
BOARD_VENDOR_SEPOLICY_DIRS += $(COMMON_PATH)/sepolicy/vendor

# Partitions
TARGET_COPY_OUT_VENDOR := vendor
BOARD_VENDORIMAGE_FILE_SYSTEM_TYPE := ext4
TARGET_COPY_OUT_PRODUCT := product
BOARD_PRODUCTIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_USES_METADATA_PARTITION := true
TARGET_USERIMAGES_USE_EXT4 := true
TARGET_USERIMAGES_USE_F2FS := true
BOARD_ROOT_EXTRA_SYMLINKS += /mnt/vendor/persist:/persist

# Recovery
TARGET_NO_RECOVERY ?= false

# Verified Boot
BOARD_AVB_ENABLE := true
BOARD_AVB_MAKE_VBMETA_IMAGE_ARGS += --flags 3
BOARD_AVB_VBMETA_SYSTEM := system
BOARD_AVB_VBMETA_SYSTEM_KEY_PATH ?= external/avb/test/data/testkey_rsa2048.pem
BOARD_AVB_VBMETA_SYSTEM_ALGORITHM ?= SHA256_RSA2048
BOARD_AVB_VBMETA_SYSTEM_ROLLBACK_INDEX := $(PLATFORM_SECURITY_PATCH_TIMESTAMP)
BOARD_AVB_VBMETA_SYSTEM_ROLLBACK_INDEX_LOCATION := 1

# USB
SOONG_CONFIG_MOTO_COMMON_USB_USB_CONTROLLER_NAME := 4e00000

# SELinux
BOARD_USE_ENFORCING_SELINUX := false

# New vendor security patch level: https://r.android.com/660840/
# Used by newer keymaster binaries
VENDOR_SECURITY_PATCH=$(PLATFORM_SECURITY_PATCH)

# Wi-Fi
WIFI_HIDL_FEATURE_DUAL_INTERFACE := true
WIFI_HIDL_UNIFIED_SUPPLICANT_SERVICE_RC_ENTRY := true

# USB
SOONG_CONFIG_NAMESPACES += MOTO_COMMON_USB MOTO_COMMON_POWER
SOONG_CONFIG_MOTO_COMMON_USB := USB_CONTROLLER_NAME
SOONG_CONFIG_MOTO_COMMON_USB_USB_CONTROLLER_NAME ?= 4e00000
SOONG_CONFIG_MOTO_COMMON_POWER := FB_IDLE_PATH
SOONG_CONFIG_MOTO_COMMON_POWER_FB_IDLE_PATH ?= /sys/devices/platform/soc/5e00000.qcom,mdss_mdp/idle_state

include device/qcom/common/BoardConfigQcom.mk
