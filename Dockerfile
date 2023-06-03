FROM debian:bullseye

ADD scripts/build.sh /build.sh
ADD scripts/run.sh /run.sh

## Install base packages
RUN chmod +x /run.sh /build.sh && sync && sleep 1 && /build.sh

EXPOSE 80

ENTRYPOINT ["/run.sh"]