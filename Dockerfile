FROM alpine:3.3
MAINTAINER Greg Poirier <greg@opsee.co>

ENV GOROOT /usr/lib/go
ENV GOPATH /gopath
ENV GOBIN /gopath/bin
ENV PATH $PATH:$GOROOT/bin:$GOPATH/bin


RUN sed -i -e 's/v3\.3/edge/g' /etc/apk/repositories; \
    echo 'http://dl-4.alpinelinux.org/alpine/edge/community' >> /etc/apk/repositories && \
    apk update; \
    apk add --update openssl bash build-base ca-certificates curl make git go postgresql-client; \
    rm -rf /var/cache/apk/* && \
    mkdir -p /build && \
    mkdir -p /gopath/bin && \
		go get -u github.com/mattes/migrate && \
		go get -u github.com/kardianos/govendor && \
    go get -u github.com/gogo/protobuf/...

VOLUME /build

COPY build.sh /build.sh

CMD ["/build.sh"]
