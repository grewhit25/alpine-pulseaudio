FROM alpine:3.10
#
ARG PUID=1001
ARG PGID=1001
ARG S6_VERSION='2.0.0.1'
#
# Install s6 overlay
RUN apk add -U wget && \
    set -ex; \
    ARCH="$(uname -m)"; \
    if [ "$ARCH" = 'armv7l' ]; then ARCH='armhf'; \
    elif [ "$ARCH" = 'x86_64' ]; then ARCH='x86'; \
    fi; \
    wget --no-check-certificate -qO /tmp/s6-overlay.tar.gz https://github.com/just-containers/s6-overlay/releases/download/v${S6_VERSION}/s6-overlay-${ARCH}.tar.gz; \
	tar xzf /tmp/s6-overlay.tar.gz -C / --exclude="./bin" && \
    tar xzf /tmp/s6-overlay.tar.gz -C /usr ./bin; \
	apk del wget
#
RUN set -xe \
    && echo "http://dl-cdn.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories \
#     && echo "http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories \
#     && echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
    && apk add --no-cache --purge -uU curl \
        bash bluez bluez-libs bluez-firmware \
        execline alsa-lib alsa-utils \
	libdaemon popt soxr libconfig avahi python3 mpg123 expect libressl2.7-libcrypto \
    pulseaudio pulseaudio-dev pulseaudio-zeroconf pulseaudio-utils pulseaudio-alsa pulseaudio-bluez pulseaudio-jack \
    && curl -o /usr/local/bin/pulsemixer -jkSL https://raw.githubusercontent.com/GeorgeFilipkin/pulsemixer/master/pulsemixer \
    && chmod +x /usr/local/bin/pulsemixer \
    && rm -rf /var/cache/apk/* /tmp/*
#
COPY root/ /
#
# VOLUME /var/run/pulse/
#
EXPOSE 4713
#
ENTRYPOINT ["/init"]
