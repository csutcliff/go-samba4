FROM Ubuntu
LABEL maintainer="Nilton OS <jniltinho@gmail.com>"

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get upgrade -y \
    && DEBIAN_FRONTEND=noninteractive apt-get -y install \
    wget git-core supervisor python3-dev \
    python3-minimal libpython3.7 libbsd0 libpopt0 libgnutls30 libldap-2.4-2 libcups2 \
    ca-certificates nginx python3-pip libjansson4 libtracker-sparql-2.0-0 libgpgme11 \
    libsasl2-dev libldap2-dev libssl-dev \
    && dpkg -i /tmp/samba.deb
    && DEBIAN_FRONTEND=noninteractive apt-get -y install \
    autoconf-archive autogen autogen-doc cmake cmake-data guile-2.2-libs libelf-dev \
    libgc1c2 libjson-c-dev libjsoncpp1 libjudy-dev libjudydebian1 liblz4-dev libmnl-dev \
    libopts25 libopts25-dev librhash0 libuv1-dev netcat netcat-openbsd

#apt install python3-zope.interface python3-zope.event python3-greenlet python-greenlet-dev python3-flask-caching python3-flask python3-netifaces python3-psutil python3-distro python3-cpuinfo py-cpuinfo

ADD scripts/build.sh /build.sh
ADD scripts/run.sh /run.sh
ADD scripts/samba.deb /tmp/

## Install base packages
RUN chmod +x /run.sh /build.sh && sync && sleep 1 && /build.sh

ADD scripts/nginx/default /etc/nginx/sites-available/default

EXPOSE 443
# EXPOSE 443 80 8088 19999
ENTRYPOINT ["/run.sh"]