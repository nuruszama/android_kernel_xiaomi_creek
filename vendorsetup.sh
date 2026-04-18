# Decompress all kernel modules in the creek-kernel directory
echo "Extracting compressed kernel modules for creek..."

for dir in device/xiaomi/creek-kernel/system_dlkm device/xiaomi/creek-kernel/vendor_dlkm device/xiaomi/creek-kernel/vendor_ramdisk; do
    if [ -d "$dir" ]; then
        find "$dir" -name "*.ko.xz" -type f | while read -r xz_file; do
            xz -d "$xz_file"
        done
    fi
done

echo "Kernel modules decompression complete."