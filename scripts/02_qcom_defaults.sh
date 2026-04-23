#!/bin/bash
set -e

FILE="hardware/qcom-caf/common/qcom_kernel_headers_defaults.bp"

mkdir -p hardware/qcom-caf/common

cat > "$FILE" <<'EOF'
cc_defaults {
    name: "qcom_kernel_headers_defaults",
    header_libs: [
        "extra_kernel_headers",
    ],
}
EOF