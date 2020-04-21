ARG UBI_IMAGE=registry.access.redhat.com/ubi7/ubi-minimal:latest

FROM goboring/golang:1.13.8b4 as builder
RUN apt update                                              && \
    apt upgrade -y                                          && \
    apt install -y apt-utils ca-certificates git bash rsync && \
    rm -rf /var/lib/apt/lists/*

RUN git clone --depth=1 https://github.com/kubernetes/kubernetes.git
RUN cd /go/kubernetes && \
    make all

FROM ${UBI_IMAGE}
RUN microdnf update -y && \
    rm -rf /var/cache/yum

COPY --from=builder /go/kubernetes/_output/bin /usr/local/bin
