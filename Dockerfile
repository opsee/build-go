FROM alpine:3.3
MAINTAINER Greg Poirier <greg@opsee.co>

ENV GOROOT /usr/lib/go
ENV GOPATH /gopath
ENV GOBIN /gopath/bin
ENV PATH $PATH:$GOROOT/bin:$GOPATH/bin

RUN sed -i -e 's/v3\.3/edge/g' /etc/apk/repositories; \
    echo 'http://dl-4.alpinelinux.org/alpine/edge/community' >> /etc/apk/repositories && \
    apk update; \
    apk add --update openssl bash build-base ca-certificates curl make git go postgresql-client m4 autoconf automake libtool; \
    rm -rf /var/cache/apk/*
RUN wget https://github.com/google/protobuf/archive/v3.0.0-beta-2.tar.gz && \
        tar -xzf v3.0.0-beta-2.tar.gz && \
        cd protobuf-3.0.0-beta-2 && \
        ./autogen.sh && \
        ./configure --disable-debug --disable-dependency-tracking --prefix=/usr && \
        make && \
        make check && \
        make install
RUN mkdir -p /build && \
    mkdir -p /gopath/bin && \
		go get -u github.com/mattes/migrate && \
		go get -u github.com/kardianos/govendor && \
    go get -u google.golang.org/grpc && \
    go get -u github.com/gogo/protobuf/proto && \
    go get -u github.com/gogo/protobuf/protoc-gen-gogo && \
    go get -u github.com/gogo/protobuf/gogoproto

VOLUME /build

COPY build.sh /build.sh

CMD ["/build.sh"]
