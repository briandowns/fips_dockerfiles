ARG UBI_IMAGE=registry.access.redhat.com/ubi7/ubi:latest

FROM goboring/golang:1.13.3b4 as builder
RUN apt update     && \
    apt upgrade -y && \
    apt install -y wget unzip btrfs-tools libseccomp-dev

RUN wget -c https://github.com/google/protobuf/releases/download/v3.11.4/protoc-3.11.4-linux-x86_64.zip && \
    unzip protoc-3.11.4-linux-x86_64.zip -d /usr/local
RUN go get github.com/containerd/containerd         && \
    go get github.com/opencontainers/runc           && \
    cd $GOPATH/src/github.com/opencontainers/runc   && \
    make static                                     && \
    make install                                    && \
    cd $GOPATH/src/github.com/containerd/containerd && \
    make                                            && \
    make install

FROM ${UBI_IMAGE}
RUN yum update -y && \
    yum upgrade -y

COPY --from=builder /go/src/github.com/containerd/containerd/bin /usr/local/bin
COPY --from=builder /go/src/github.com/opencontainers/runc/runc /usr/local/bin
