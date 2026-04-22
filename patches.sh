#!/bin/bash
echo "[+] Starting Creek Device Patches..."

# Fix 1: QCOM Defs upgrade logic (Bengal 4.19 -> 5.15)
QCOM_DEFS="hardware/qcom-caf/common/qcom_defs.mk"
if [ -f "$QCOM_DEFS" ]; then
    if ! grep -q "UM 4.19 upgraded to UM 5.15" "$QCOM_DEFS"; then
        echo -e "\nifeq (\$(TARGET_KERNEL_VERSION),5.15)\n#UM 4.19 upgraded to UM 5.15\nUM_5_15_FAMILY := \$(UM_5_15_FAMILY) \$(UM_4_19_FAMILY)\nUM_4_19_FAMILY :=\nendif" >> "$QCOM_DEFS"
        echo "    [*] Applied 5.15 upgrade logic to $QCOM_DEFS"
    fi
fi

# Fix 2: Missing msm_audio.h in ar_osal (SM8550 CAF path)
BP_FILE="hardware/qcom-caf/sm8550/audio/graphservices/ar_osal/Android.bp"
if [ -f "$BP_FILE" ]; then
    if ! grep -q "device/xiaomi/creek-kernel/include/uapi" "$BP_FILE"; then
        sed -i '/include_dirs: \[/a \        "device/xiaomi/creek-kernel/include/uapi",' "$BP_FILE"
        echo "    [*] Patched $BP_FILE for Bengal headers"
    fi
fi

# Fix 3: Missing drm/sde_drm.h in sde-drm
SDE_DRM_BP="hardware/qcom-caf/sm8250/display/sde-drm/Android.bp"
if [ -f "$SDE_DRM_BP" ]; then
    if ! grep -q "device/xiaomi/creek-kernel/include/uapi" "$SDE_DRM_BP"; then
        # Inject path into the include_dirs block
        sed -i '/include_dirs: \[/a \        "device/xiaomi/creek-kernel/include/uapi",' "$SDE_DRM_BP"
        echo "    [*] Patched $SDE_DRM_BP for sde_drm.h"
    fi
fi

# Fix 4: Missing media/msm_media_info.h in Gralloc
GRALLOC_BP="hardware/qcom-caf/sm8250/display/gralloc/Android.bp"
if [ -f "$GRALLOC_BP" ]; then
    if ! grep -q "device/xiaomi/creek-kernel/include/uapi" "$GRALLOC_BP"; then
        # Gralloc often uses common_deps or specific library blocks; we'll target the include_dirs
        sed -i '/include_dirs: \[/a \        "device/xiaomi/creek-kernel/include/uapi",' "$GRALLOC_BP"
        echo "    [*] Patched $GRALLOC_BP for msm_media_info.h"
    fi
fi

# Add more patches here as they come up...

echo "[+] All device patches applied successfully."
