#!/bin/bash
echo "[+] Running Creek Hardware Seasoning..."

# 1. THE QCOM DEFS FIX (Bengal 4.19 -> 5.15 Family)
QCOM_DEFS="hardware/qcom-caf/common/qcom_defs.mk"
if [ -f "$QCOM_DEFS" ] && ! grep -q "UM 4.19 upgraded to UM 5.15" "$QCOM_DEFS"; then
    echo -e "\nifeq (\$(TARGET_KERNEL_VERSION),5.15)\n#UM 4.19 upgraded to UM 5.15\nUM_5_15_FAMILY := \$(UM_5_15_FAMILY) \$(UM_4_19_FAMILY)\nUM_4_19_FAMILY :=\nendif" >> "$QCOM_DEFS"
    echo "    [*] Applied 5.15 upgrade logic."
fi

# 2. THE MASS HEADER FIX
# This is the path you confirmed contains the 'linux', 'drm', and 'media' folders
HEADER_PATH="device/xiaomi/creek-kernel/kernel-headers/usr/include"

TARGET_DIRS=(
    "hardware/qcom-caf/sm8550/audio/graphservices/ar_osal"
    "hardware/qcom-caf/sm8250/display/sde-drm"
    "hardware/qcom-caf/sm8250/display/gralloc"
)

for DIR in "${TARGET_DIRS[@]}"; do
    BP="$DIR/Android.bp"
    if [ -f "$BP" ]; then
        if ! grep -q "$HEADER_PATH" "$BP"; then
            # Inject the correct path into the include_dirs block
            sed -i "/include_dirs: \[/a \        \"$HEADER_PATH\"," "$BP"
            echo "    [*] Patched $BP with correct header path."
        fi
    fi
done

echo "[+] Seasoning complete. Ready for bacon."
