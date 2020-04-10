ARG UBI_IMAGE=registry.access.redhat.com/ubi8/ubi:latest

FROM goboring/golang:1.13.8b4 as builder
RUN apt update                                   && \
    apt upgrade -y                               && \
    apt install -y apt-utils ca-certificates git    \
                   bash build-essential libc-bin    \
                   rsync libc-pic libc-dev

RUN git clone --depth=1 https://github.com/briandowns/kubernetes.git
RUN cd /go/kubernetes && \
    make all GOLDFLAGS=''

FROM builder as strip
ARG SEARCH_KEY=boring
RUN go tool nm /go/kubernetes/_output/bin/kubectl > /kubectl_symbol_table.txt && \
    grep ${SEARCH_KEY} /kubectl_symbol_table.txt                              && \
    cd /go/kubernetes                                                         && \
    make all

FROM ${UBI_IMAGE}
RUN yum update -y  && \
    yum upgrade -y && \
    yum install -y binutils
COPY --from=strip /go/kubernetes/_output/bin/kubectl .
CMD ["objdump", "-s" "/kubectl"]
