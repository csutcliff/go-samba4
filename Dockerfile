FROM debian:bullseye

ENV DEBIAN_FRONTEND=noninteractive

ADD scripts/build.sh /build.sh
ADD scripts/run.sh /run.sh

## Install base packages
RUN chmod +x /run.sh /build.sh && sync && sleep 1 && /build.sh

EXPOSE 443
# EXPOSE 443 80 8088 19999
ENTRYPOINT ["/run.sh"]