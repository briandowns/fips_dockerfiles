ARG UBI_IMAGE=registry.access.redhat.com/ubi7/ubi-minimal:latest

FROM goboring/golang:1.13.9b4 as builder
RUN apt update                         && \
    apt upgrade -y                     && \
    apt install -y ca-certificates git && \
    rm -rf /var/lib/apt/lists/*

RUN git clone --depth=1 https://github.com/coredns/coredns.git
RUN cd /go/coredns && \
    CGO_ENABLED=1 make all

FROM ${UBI_IMAGE}
RUN microdnf update -y && \
    rm -rf /var/cache/yum

COPY --from=builder /go/coredns/coredns /usr/local/bin
