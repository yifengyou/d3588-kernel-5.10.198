#!/bin/bash

set -ex

make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- menuconfig

echo "All done! [$?]"

