FROM quay.io/opsee/build-base
MAINTAINER Greg Poirier <greg@opsee.co>

ENV GOROOT /usr/lib/go
ENV GOPATH /gopath
ENV GOBIN /gopath/bin
ENV PATH $PATH:$GOROOT/bin:$GOPATH/bin


RUN sed -i -e 's/v3\.2/edge/g' /etc/apk/repositories; \
    apk update; \
    apk add curl make git go; \
    rm -rf /var/cache/apk/* && \
    mkdir -p /build && \
    mkdir -p /gopath/bin #&& \
    go get github.com/constabulary/gb/... && \
	go get github.com/mattes/migrate

VOLUME /build

COPY build.sh /build.sh

CMD ["/build.sh"]
