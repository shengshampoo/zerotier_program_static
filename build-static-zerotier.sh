
#! /bin/bash

set -e

WORKSPACE=/tmp/workspace
mkdir -p $WORKSPACE
mkdir -p /work/artifact

HOST_OS=$(uname -s)
HOST_ARCH=$(uname -m)

git clone https://github.com/zerotier/ZeroTierOne.git
cd ZeroTierOne
sed -i -e "s/cargo build/cargo build --target ${HOST_ARCH}-chimera-linux-musl/g" ./make-linux.mk
sed -i -e "/^DESTDIR?=/s/=/=\/usr\/local\/zerotiermm/" ./make-linux.mk
sed -i -e "s@rustybits/target/release@rustybits/target/${HOST_ARCH}-chimera-linux-musl/release@g" ./make-linux.mk
sed -i -e "s@rustybits/target/debug@rustybits/target/${HOST_ARCH}-chimera-linux-musl/debug@g" ./make-linux.mk
make
make install

cd /usr/local
tar vcJf ./zerotiermm.tar.xz zerotiermm

mv ./zerotiermm.tar.xz /work/artifact/
