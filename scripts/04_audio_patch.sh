#!/bin/bash
set -e

FILE="hardware/qcom-caf/sm8550/audio/graphservices/ar_osal/Android.bp"

if [ -f "$FILE" ]; then
  echo "[*] Patching audio defaults..."

  grep -q "qcom_kernel_headers_defaults" "$FILE" || \
  awk '
    /cc_library_shared|cc_library/ && !done {
      print;
      print "    defaults: [\"qcom_kernel_headers_defaults\"],";
      done=1;
      next;
    }
    {print}
  ' "$FILE" > "$FILE.tmp" && mv "$FILE.tmp" "$FILE"
fi