FROM gliderlabs/alpine:3.2
MAINTAINER Greg Poirier <greg@opsee.co>

ENV GOROOT /usr/lib/go
ENV GOPATH /gopath
ENV GOBIN /gopath/bin
ENV PATH $PATH:$GOROOT/bin:$GOPATH/bin

RUN apk update && \
    apk add curl git mercurial bzr go bash && \
    rm -rf /var/cache/apk/* && \
    mkdir -p /build && \
    mkdir -p /gopath/bin && \
    go get github.com/constabulary/gb/...

VOLUME /build

COPY build.sh /build.sh

CMD ["/build.sh"]
