FROM alpine:latest
RUN apk add --no-cache unison
WORKDIR /data
CMD /usr/bin/unison -copymax 2 -socket 5000
