#!/bin/bash

set -ex

make ARCH=arm64 savedefconfig
cp -a defconfig arch/arm64/configs/d3588_defconfig

echo "All done! [$?]"

