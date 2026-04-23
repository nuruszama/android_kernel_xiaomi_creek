#!/bin/bash
set -e

FILES=(
  "hardware/qcom-caf/sm8250/display/sde-drm/Android.bp"
  "hardware/qcom-caf/sm8250/display/gralloc/Android.bp"
)

for f in "${FILES[@]}"; do
  if [ -f "$f" ]; then

    echo "[*] Patching $f"

    grep -q "qcom_kernel_headers_defaults" "$f" || \
    awk '
      /cc_library_shared|cc_binary/ && !done {
        print;
        print "    defaults: [\"qcom_kernel_headers_defaults\"],";
        done=1;
        next;
      }
      {print}
    ' "$f" > "$f.tmp" && mv "$f.tmp" "$f"
  fi
done