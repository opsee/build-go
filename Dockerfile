FROM quay.io/opsee/build-base
MAINTAINER Greg Poirier <greg@opsee.co>

ENV GOROOT /usr/lib/go
ENV GOPATH /gopath
ENV GOBIN /gopath/bin
ENV PATH $PATH:$GOROOT/bin:$GOPATH/bin

RUN apk update && \
    apk add curl git mercurial bzr go bash build-base m4 autoconf automake libtool && \
    wget https://github.com/google/protobuf/archive/v3.0.0-alpha-3.tar.gz && \
    tar -xzf v3.0.0-alpha-3.tar.gz && \
    cd protobuf-3.0.0-alpha-3 && \
    ./autogen.sh && \
    ./configure --disable-debug --disable-dependency-tracking && \
    make && \
    make install && \
    cd .. && \
    go get -a github.com/golang/protobuf/protoc-gen-go && \
    rm -rf /var/cache/apk/* && \
    mkdir -p /build && \
    mkdir -p /gopath/bin && \
    go get github.com/constabulary/gb/...

VOLUME /build

COPY build.sh /build.sh

CMD ["/build.sh"]
