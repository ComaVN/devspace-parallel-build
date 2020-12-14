FROM alpine:3.12

# build-arg to make sure each `devspace build` needs a full rebuild
ARG timestamp

# Sleep a smallish amount of time, to make sure the first build isn't ready before the second one is started
RUN sleep 3

RUN dd if=/dev/urandom of=/data.bin bs=16 count=1

CMD [ "sh", "-c", "while true; do md5sum /data.bin; sleep 1; done" ]
