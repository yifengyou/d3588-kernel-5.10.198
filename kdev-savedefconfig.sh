#!/bin/bash

set -ex

make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- savedefconfig
cp -a defconfig arch/arm64/configs/d3588_defconfig

echo "All done! [$?]"

