FROM Ubuntu
LABEL maintainer="Nilton OS <jniltinho@gmail.com>"

ADD scripts/build_deb.sh /

## Install base packages
RUN chmod +x /build_deb.sh && sync && sleep 2 && /build_deb.sh
