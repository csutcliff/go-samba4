FROM ubuntu AS builder

ENV DEBIAN_FRONTEND=noninteractive
ADD scripts/build_deb.sh /
RUN apt-get update \
    && apt-get upgrade -y \
    && DEBIAN_FRONTEND=noninteractive apt-get -yq install \
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

FROM ubuntu

COPY --from=builder /opt/samba.deb /samba.deb
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get upgrade -y \
    && DEBIAN_FRONTEND=noninteractive apt-get -yq install \
    wget git-core supervisor python3-dev \
    python3-minimal libpython3.7 libbsd0 libpopt0 libgnutls30 libldap-2.4-2 libcups2 \
    ca-certificates nginx python3-pip libjansson4 libtracker-sparql-2.0-0 libgpgme11 \
    libsasl2-dev libldap2-dev libssl-dev libunwind8 liblmdb0 \
    && DEBIAN_FRONTEND=noninteractive apt-get -yq install \
    autoconf-archive autogen autogen-doc cmake cmake-data guile-2.2-libs libelf-dev \
    libgc1c2 libjson-c-dev libjsoncpp1 libjudy-dev libjudydebian1 liblz4-dev libmnl-dev \
    libopts25 libopts25-dev librhash0 libuv1-dev netcat netcat-openbsd curl libltdl-dev uwsgi-plugin-gevent-python3 \
    pkg-config uuid-dev
    && DEBIAN_FRONTEND=noninteractive apt -yq install mingw-w64
#mingw-w64 (roughly 1gb) for arm64 (execution format error)?

ADD scripts/build.sh /build.sh
ADD scripts/run.sh /run.sh

## Install base packages
RUN chmod +x /run.sh /build.sh && sync && sleep 1 && /build.sh

ENTRYPOINT ["/run.sh"]
