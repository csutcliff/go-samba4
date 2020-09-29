#!/bin/bash
set -e
DEBIAN_FRONTEND=noninteractive

apt-get update
apt-get -yq install wget git-core supervisor python3-dev \
 python3-minimal libpython3.8 libbsd0 libpopt0 libgnutls30 libldap-2.4-2 libcups2 \
 ca-certificates nginx python3-pip libjansson4 libtracker-sparql-2.0-0 libgpgme11 \
 libsasl2-dev libldap2-dev libssl-dev 
 
#apt-get install guile-2.0-libs libaio1 libfile-copy-recursive-perl libfribidi0 libgc1c2 libgsasl7 libkyotocabinet16v5 libldb1 libltdl7 liblzo2-2 libmailutils5 libmariadbclient18 libntlm0 libtalloc2 libtdb1 libtevent0 libwbclient0 libwrap0 python3 attr python-dnspython python-ldb python-samba python-talloc python-tdb

#apt install python-zope.interface python-zope.event python3-greenlet python-greenlet-dev

dpkg -i /tmp/samba-*.amd64.deb

cd /tmp/
git clone https://github.com/burnbabyburn/go-samba4.git
cd go-samba4
rm -rf dist/*
pip3 install pyasn1 --upgrade
pip3 install -r requirements.txt
python3 make_bin.py go_samba4.py
mv /tmp/go-samba4/dist /opt/go-samba4
chmod +x /opt/go-samba4/go_samba4

cd /tmp/
wget https://my-netdata.io/kickstart.sh
/bin/bash kickstart.sh --dont-wait --dont-start-it
cp /opt/netdata/system/netdata-lsb /etc/init.d/netdata
chmod +x /etc/init.d/netdata

cd /
apt-get clean
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /var/cache/apt/archive/*.deb

echo '[supervisord] 
nodaemon=true

[program:go_samba4]
directory=/opt/go-samba4
autostart=true
autorestart=true
command=/opt/go-samba4/go_samba4 --server-prod --ssl

[program:nginx]
command=/usr/sbin/nginx -g "daemon off;"
autostart=true
autorestart=true
#user=nobody' > /etc/supervisord.conf

mv /etc/nginx/sites-available/default /etc/nginx/sites-available/default_old_$$
