ARG UBI_IMAGE=registry.access.redhat.com/ubi8/ubi:latest

FROM goboring/golang:1.13.3b4 as builder
RUN apt update                                   && \
    apt upgrade -y                               && \
    apt install -y apt-utils ca-certificates git    \
                   bash build-essential libc-bin    \
                   libc-pic libc-dev

RUN git clone --depth=1 https://github.com/etcd-io/etcd.git
RUN cd /go/etcd                                                                           && \
    make build

FROM builder as strip
ARG SEARCH_KEY=boring
RUN go tool nm /go/kubernetes/_output/bin/kubectl > /kubectl_symbol_table.txt && \
    grep ${SEARCH_KEY} /kubectl_symbol_table.txt                              && \
    cd /go/kubernetes                                                         && \
    make all

FROM ${UBI_IMAGE}
RUN yum update -y  && \
    yum upgrade -y && \
    yum install -y binutils file gdb
COPY --from=builder /go/etcd/bin/etcd .
CMD ["objdump", "-s", "/etcd"]
