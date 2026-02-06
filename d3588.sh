#!/bin/bash

set -xe

# set config
cp -a d3588_defconfig ./arch/arm64/configs/d3588_defconfig
make ARCH=arm64 \
	CROSS_COMPILE=aarch64-linux-gnu- \
	KBUILD_BUILD_USER="builder" \
	KBUILD_BUILD_HOST="kdevbuilder" \
	d3588_defconfig

# check kver
KVER=$(make kernelrelease)
KVER="${KVER/kdev*/kdev}"
if [[ "$KVER" != *kdev ]]; then
    echo "ERROR: KVER does not end with 'kdev'"
    exit 1
fi
echo "KVER: ${KVER}"

# build dtb
#dtc -I dts -O dtb d3588.dts -o d3588.dtb

# build kernel
make ARCH=arm64 \
	CROSS_COMPILE=aarch64-linux-gnu- \
	KBUILD_BUILD_USER="builder" \
	KBUILD_BUILD_HOST="kdevbuilder" \
	-j `nproc`

# build modules
make ARCH=arm64 \
	CROSS_COMPILE=aarch64-linux-gnu- \
	KBUILD_BUILD_USER="builder" \
	KBUILD_BUILD_HOST="kdevbuilder" \
	modules -j`nproc`

# install modules
mkdir -p ../rockdev/modules
find . -name "*.ko" |xargs -i cp {} ../rockdev/modules/


dd if=/dev/zero of=../rockdev/boot.img bs=1M count=60

sudo mkfs.ext2 -U 7A3F0000-0000-446A-8000-702F00006273 -L kdevboot ../rockdev/boot.img
sudo mount ../rockdev/boot.img /mnt
#sudo mkdir -p /mnt/dtb

#sudo cp -f d3588.dtb /mnt/dtb
sudo cp -f arch/arm64/boot/Image /mnt/vmlinuz-${KVER}
sudo cp -f .config /mnt/config-${KVER}
sudo cp -f System.map /mnt/System.map-${KVER}
sudo touch /mnt/initrd.img-${KVER}
sudo mkdir -p /mnt/extlinux/
sudo cp -f extlinux.conf /mnt/extlinux/
sudo cp -f extlinux.conf /mnt/
sudo cp -f armbian_first_run.txt /mnt/

sudo find /mnt
sync
sudo umount /mnt

echo "All done!"

