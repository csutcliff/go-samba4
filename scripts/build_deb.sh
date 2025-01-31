#!/bin/bash

gem install fpm

cd /tmp/

get_samba4=https://download.samba.org/pub/samba/stable/samba-4.13.0.tar.gz

PKG=$(basename ${get_samba4}|sed "s/.tar.gz//")
PKG_NAME=$(basename ${get_samba4}|sed "s/.tar.gz//"|cut -d- -f1)
PKG_VERSION=$(basename ${get_samba4}|sed "s/.tar.gz//"|cut -d- -f2)

wget -c ${get_samba4}
tar xvfz $(basename ${get_samba4})
cd $(basename ${get_samba4}|sed "s/.tar.gz//")
./configure --with-ads --systemd-install-services --with-shared-modules=ALL --with-gpgme --enable-debug --enable-selftest --with-json --with-systemd --enable-spotlight --with-regedit --prefix=/opt/samba4

make -j$(nproc)
make install DESTDIR=/tmp/installdir

mkdir -p /tmp/installdir/etc/systemd/system

fpm -s dir -t deb -n ${PKG_NAME} -v ${PKG_VERSION} -C /tmp/installdir \
  -d "python3-minimal" \
  -d "libpython3.8" \
  -d "libbsd0" \
  -d "libpopt0" \
  -d "libgnutls30" \
  -d "libldap-2.4-2" \
  -d "libcups2" \
  -d "libjansson4" \
  -d "libgpgme11" \
  -d "libunwind8" \
  -d "liblmdb0" \
  -p samba.deb .

mv samba.deb /opt/