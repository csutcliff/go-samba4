#!/bin/bash
set -e
DEBIAN_FRONTEND=noninteractive

apt-get update
apt-get upgrade -y
apt-get -yq install \
    wget git-core supervisor python3-dev \
    python3-minimal libpython3.7 libbsd0 libpopt0 libgnutls30 libldap-2.4-2 libcups2 \
    ca-certificates nginx python3-pip libjansson4 libtracker-sparql-2.0-0 libgpgme11 \
    libsasl2-dev libldap2-dev libssl-dev

cd /tmp/
git clone https://github.com/csutcliff/go-samba4.git
cd go-samba4
rm -rf dist/*
pip3 install -r requirements.txt
python3 make_bin.py go_samba4.py
mv /tmp/go-samba4/dist /opt/go-samba4
chmod +x /opt/go-samba4/go_samba4

rm /etc/nginx/sites-available/default && cp /tmp/go-samba4/scripts/nginx/default /etc/nginx/sites-available/default
cp /tmp/go-samba4/scripts/supervisord/supervisord.conf /etc/supervisord.conf

cd /
apt-get clean
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /var/cache/apt/archive/*.deb 