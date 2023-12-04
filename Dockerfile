FROM alpine:3.18

ARG VERSION

RUN set -xe && \
    apk add --no-cache \
        tzdata \
        yq \
        samba-server \
        samba-common-tools

COPY rootfs /

VOLUME /mount
EXPOSE 445/tcp

RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["/usr/bin/entrypoint.sh"]

CMD smbd --foreground \
         --debug-stdout \
         --no-process-group \
         --configfile /etc/samba/smb.conf