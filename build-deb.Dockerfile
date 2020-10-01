FROM Ubuntu
LABEL maintainer="Nilton OS <jniltinho@gmail.com>"

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get upgrade -y \
    && DEBIAN_FRONTEND=noninteractive apt-get -y install \
    acl apt-utils attr autoconf bind9utils binutils bison \
    build-essential chrpath curl debhelper dnsutils docbook-xml \
    docbook-xsl flex gcc gdb git glusterfs-common gzip heimdal-multidev \
    hostname htop lcov libacl1-dev \
    libarchive-dev libattr1-dev libavahi-common-dev libblkid-dev \
    libbsd-dev libcap-dev libcephfs-dev libcups2-dev libdbus-1-dev \
    libglib2.0-dev libgnutls28-dev libgpgme11-dev libicu-dev libjansson-dev \
    libjs-jquery libjson-perl libkrb5-dev libldap2-dev liblmdb-dev \
    libncurses5-dev libpam0g-dev libparse-yapp-perl libpcap-dev libpopt-dev \
    libreadline-dev libsystemd-dev libtasn1-bin libtasn1-dev libunwind-dev \
    lmdb-utils locales lsb-release make mawk patch perl perl-modules \
    pkg-config procps psmisc python3 python3-dbg python3-dev python3-dnspython \
    python3-gpg python3-iso8601 python3-markdown python3-matplotlib \
    python3-pexpect rng-tools rsync sed sudo tar tree uuid-dev \
    xfslibs-dev xsltproc zlib1g-dev libtracker-sparql-2.0-dev ruby-dev wget \
    && chmod +x /build_deb.sh && sync && sleep 2 && /build_deb.sh

ADD scripts/build_deb.sh /