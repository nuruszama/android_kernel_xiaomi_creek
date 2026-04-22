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

# Add more patches here as they come up...

echo "[+] All device patches applied successfully."
