#!/bin/bash
set -e
REALM="LINUXPRO.NET"
DOMAIN="LINUXPRO"
LDAPDN=",DC=linuxpro,DC=net"
NETBIOS="linuxpro"
ADMINPASS="Linuxpro123456"

cd /tmp/
git clone https://github.com/burnbabyburn/go-samba4.git
cd go-samba4
dpkg -i /tmp/go-samba4/scripts/samba.deb
rm -rf dist/*
pip3 install -r requirements.txt
python3 make_bin.py go_samba4.py
mv /tmp/go-samba4/dist /opt/go-samba4
chmod +x /opt/go-samba4/go_samba4

cd /tmp/
wget https://my-netdata.io/kickstart.sh
/bin/bash kickstart.sh --dont-wait --dont-start-it

echo '[supervisord] 
nodaemon=true

[program:go_samba4]
directory=/opt/go-samba4
autostart=true
autorestart=true
command=/opt/go-samba4/go_samba4 --server-prod --ssl

[program:samba]
directory=/opt/samba4
autostart=true
autorestart=true
command=/opt/samba4/sbin/samba -F

[program:netdata]
autostart=true
autorestart=true
command=/usr/sbin/netdata -D

[program:nginx]
command=/usr/sbin/nginx -g "daemon off;"
autostart=true
autorestart=true
#user=nobody' > /etc/supervisord.conf

### Create Domain
/opt/samba4/bin/samba-tool domain provision --server-role=dc --use-rfc2307 \
 --dns-backend=SAMBA_INTERNAL --realm=$REALM --domain=$DOMAIN \
 --adminpass=$ADMINPASS
 
IMAP_ID_START=${IMAP_UID_START:-10000}
IMAP_UID_START=${IMAP_UID_START:-$IMAP_ID_START}
IMAP_GID_START=${IMAP_GID_START:-$IMAP_ID_START}
 
GID_DOM_USER=$((IMAP_GID_START))
GID_DOM_ADMIN=$((IMAP_GID_START+1))
GID_DOM_COMPUTERS=$((IMAP_GID_START+2))
GID_DOM_DC=$((IMAP_GID_START+3))
GID_DOM_GUEST=$((IMAP_GID_START+4))
GID_SCHEMA=$((IMAP_GID_START+5))
GID_ENTERPRISE=$((IMAP_GID_START+6))
GID_GPO=$((IMAP_GID_START+7))
GID_RDOC=$((IMAP_GID_START+8))
GID_DNSUPDATE=$((IMAP_GID_START+9))
GID_ENTERPRISE_RDOC=$((IMAP_GID_START+10))
GID_DNSADMIN=$((IMAP_GID_START+11))
GID_ALLOWED_RDOC=$((IMAP_GID_START+12))
GID_DENIED_RDOC=$((IMAP_GID_START+13))
GID_RAS=$((IMAP_GID_START+14))
GID_CERT=$((IMAP_GID_START+15))
UID_KRBTGT=$((IMAP_UID_START))
UID_GUEST=$((IMAP_UID_START+1))
UID_ADMINISTRATOR=$((IMAP_UID_START+2))
IMAP_GID_END=$((IMAP_GID_START+16))
IMAP_UID_END=$((IMAP_UID_START+3))

sed -e "s: {{ LDAPDN }}:$LDAPDN:g" \
 -e "s:{{ NETBIOS }}:$NETBIOS:g" \
 -e "s:{{ GID_DOM_USER }}:$GID_DOM_USER:g" \
 -e "s:{{ GID_DOM_ADMIN }}:$GID_DOM_ADMIN:g" \
 -e "s:{{ GID_DOM_COMPUTERS }}:$GID_DOM_COMPUTERS:g" \
 -e "s:{{ GID_DOM_DC }}:$GID_DOM_DC:g" \
 -e "s:{{ GID_DOM_GUEST }}:$GID_DOM_GUEST:g" \
 -e "s:{{ GID_SCHEMA }}:$GID_SCHEMA:g" \
 -e "s:{{ GID_ENTERPRISE }}:$GID_ENTERPRISE:g" \
 -e "s:{{ GID_GPO }}:$GID_GPO:g" \
 -e "s:{{ GID_RDOC }}:$GID_RDOC:g" \
 -e "s:{{ GID_DNSUPDATE }}:$GID_DNSUPDATE:g" \
 -e "s:{{ GID_ENTERPRISE_RDOC }}:$GID_ENTERPRISE_RDOC:g" \
 -e "s:{{ GID_DNSADMIN }}:$GID_DNSADMIN:g" \
 -e "s:{{ GID_ALLOWED_RDOC }}:$GID_ALLOWED_RDOC:g" \
 -e "s:{{ GID_DENIED_RDOC }}:$GID_DENIED_RDOC:g" \
 -e "s:{{ GID_RAS }}:$GID_RAS:g" \
 -e "s:{{ GID_CERT }}:$GID_CERT:g" \
 -e "s:{{ UID_KRBTGT }}:$UID_KRBTGT:g" \
 -e "s:{{ UID_GUEST }}:$UID_GUEST:g" \
 -e "s:{{ UID_ADMINISTRATOR }}:$UID_ADMINISTRATOR:g" \
 -e "s:{{ IMAP_UID_END }}:$IMAP_UID_END:g" \
 -e "s:{{ IMAP_GID_END }}:$IMAP_GID_END:g" \
     /tmp/go-samba4/scripts/samba/RFC_Domain_User_Group.ldif.j2 > /opt/samba4/RFC_Domain_User_Group.ldif
/opt/samba4/bin/ldbmodify -H /opt/samba4/private/sam.ldb /opt/samba4/RFC_Domain_User_Group.ldif -U Administrator


rm /etc/nginx/sites-available/default
cp /tmp/go-samba4/scripts/nginx/default /etc/nginx/sites-available/default
cd /
apt-get clean
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /var/cache/apt/archive/*.deb