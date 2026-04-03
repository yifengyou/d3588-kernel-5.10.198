#!/bin/bash

set -ex

make ARCH=arm64 menuconfig

echo "All done! [$?]"

