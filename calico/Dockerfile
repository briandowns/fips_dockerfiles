ARG UBI_IMAGE=registry.access.redhat.com/ubi7/ubi-minimal:latest

FROM goboring/golang:1.13.9b4 as builder
RUN apt update                                      && \
    apt upgrade -y                                  && \
    apt install -y apt-transport-https ca-certificates \
                   software-properties-common git      \
                   curl bash

RUN git clone --depth=1 https://github.com/projectcalico/calicoctl.git
RUN cd /go/calicoctl                                                                                                                                 && \
    mkdir bin                                                                                                                                        && \
    CGO_ENABLED=1 go build -v -o bin/calicoctl -ldflags "-X github.com/projectcalico/calicoctl/calicoctl/commands.VERSION=$(git rev-parse --short HEAD) \
    -X github.com/projectcalico/calicoctl/calicoctl/commands.GIT_REVISION=$(git rev-parse --short HEAD) -s -w" "./calicoctl/calicoctl.go"            && \
    cd /go
RUN git clone --depth=1 https://github.com/projectcalico/cni-plugin.git
RUN cd /go/cni-plugin                                                                                                             && \
    mkdir bin                                                                                                                     && \
    CGO_ENABLED=1 go build -v -o bin/calico -ldflags "-X main.VERSION=$(git rev-parse --short HEAD) -s -w" ./cmd/calico           && \
    CGO_ENABLED=1 go build -v -o bin/calico-ipam -ldflags "-X main.VERSION=$(git rev-parse --short HEAD) -s -w" ./cmd/calico-ipam && \
    cd /go
RUN git clone --depth=1 https://github.com/projectcalico/node.git
RUN cd /go/node                                                                                                                                                 && \
    mkdir -p dist/bin                                                                                                                                           && \
    CGO_ENABLED=1 go build -v -o dist/bin/calico-node -ldflags "-X github.com/projectcalico/node/pkg/startup.VERSION=$(git describe --tags --dirty --always)       \
    -X github.com/projectcalico/node/buildinfo.GitVersion=$(git describe --tags --dirty --always)                                                                  \
    -X github.com/projectcalico/node/buildinfo.BuildDate=$(date -u +'%FT%T%z')                                                                                     \
    -X github.com/projectcalico/node/buildinfo.GitRevision=$(git rev-parse HEAD)" ./cmd/calico-node/main.go

FROM ${UBI_IMAGE}
RUN microdnf update -y && \
    rm -rf /var/cache/yum

COPY --from=builder /go/calicoctl/bin  /bin
COPY --from=builder /go/cni-plugin/bin /bin
COPY --from=builder /go/node/dist/bin  /bin
