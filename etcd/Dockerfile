ARG UBI_IMAGE=registry.access.redhat.com/ubi7/ubi:latest

FROM goboring/golang:1.13.3b4 as builder
RUN apt update && apt upgrade -y

RUN git clone --depth=1 https://github.com/etcd-io/etcd.git
RUN cd /go/etcd && \
    make build

FROM ${UBI_IMAGE}
RUN yum update -y && \
    yum upgrade -y

COPY --from=builder /go/etcd/bin/etcd /usr/local/bin
COPY --from=builder /go/etcd/bin/etcdctl /usr/local/bin
