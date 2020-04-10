ARG UBI_IMAGE=registry.access.redhat.com/ubi8/ubi:latest

FROM goboring/golang:1.13.3b4 as builder
RUN apt update                                   && \
    apt upgrade -y                               && \
    apt install -y apt-utils ca-certificates git    \
                   bash build-essential libc-bin    \
                   libc-pic libc-dev

RUN git clone --depth=1 https://github.com/etcd-io/etcd.git
RUN cd /go/etcd && \
    make build

FROM builder as strip
ARG SEARCH_KEY=boring
RUN go tool nm /go/etcd/bin/etcdctl > /etcdctl_symbol_table.txt && \
    grep ${SEARCH_KEY} /etcdctl_symbol_table.txt && \
    cd /go/etcd                                  && \
    make build

FROM ${UBI_IMAGE}
RUN yum update -y  && \
    yum upgrade -y && \
    yum install -y binutils file
COPY --from=strip /go/etcd/bin/etcd .
COPY --from=strip /go/etcd/bin/etcdctl .
CMD ["objdump", "-s", "/etcd"]
