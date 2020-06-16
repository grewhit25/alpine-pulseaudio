FROM woahbase/alpine-pulseaudio:armhf
#
COPY root/ /
#
# VOLUME /var/run/pulse/
#
EXPOSE 4713
#
#ENTRYPOINT ["/bin/bash"]
