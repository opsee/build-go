FROM quay.io/opsee/build-base
MAINTAINER Greg Poirier <greg@opsee.co>

ENV GOROOT /usr/lib/go
ENV GOPATH /gopath
ENV GOBIN /gopath/bin
ENV PATH $PATH:$GOROOT/bin:$GOPATH/bin

RUN apk add --update go && \
    #go get -a github.com/golang/protobuf/protoc-gen-go && \
    mkdir -p /gopath/src/github.com/golang && cd /gopath/src/github.com/golang && git clone https://github.com/golang/protobuf.git && \
    cd protobuf && git checkout 8081512d5bf6d07341a19043dac2396eec31bbe6 && cd protoc-gen-go && go build && go install && \
    rm -rf /var/cache/apk/* && \
    mkdir -p /build && \
    mkdir -p /gopath/bin && \
    go get github.com/constabulary/gb/... && \
		go get github.com/mattes/migrate

VOLUME /build

COPY build.sh /build.sh

CMD ["/build.sh"]
