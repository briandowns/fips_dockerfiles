ARG UBI_IMAGE=registry.access.redhat.com/ubi7/ubi-minimal:latest

FROM goboring/golang:1.10.3b4 as builder
RUN apt update                         && \
    apt upgrade -y                     && \
    apt install -y ca-certificates git && \
    rm -rf /var/lib/apt/lists/*
RUN curl https://glide.sh/get | sh

RUN git clone --depth=1 https://github.com/coreos/flannel.git
RUN mkdir -p /go/src/github.com/coreos && \
    mv flannel /go/src/github.com/coreos
RUN cd /go/src/github.com/coreos/flannel && \
    CGO_ENABLED=1 make dist/flanneld

FROM ${UBI_IMAGE}
RUN microdnf update -y && \
    rm -rf /var/cache/yum

COPY --from=builder /go/src/github.com/coreos/flannel/dist/flanneld /usr/local/bin
