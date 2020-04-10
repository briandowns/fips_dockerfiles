ARG UBI_IMAGE=registry.access.redhat.com/ubi8/ubi:latest

FROM goboring/golang:1.13.9b4 as builder
RUN apt update && apt upgrade -y                                                                  && \
    apt install -y ca-certificates git bash build-essential rsync curl                            && \
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -                             && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt-get update                                                                                && \                                                                 
    apt install -y npm nodejs yarn                                                                && \
    rm -rf /var/lib/apt/lists/*

ENV GO111MODULE=on
RUN git clone --depth=1 https://github.com/prometheus/prometheus.git
RUN cd prometheus && \
    make build

FROM builder as unstripped
ARG SEARCH_KEY=boring
RUN go tool nm /go/prometheus/prometheus > /prometheus_symbol_table.txt && \
    grep ${SEARCH_KEY} /prometheus_symbol_table.txt                     && \
    cd /go/prometheus                                                   && \
    make build

FROM ${UBI_IMAGE}
RUN yum update -y  && \
    yum upgrade -y && \
    yum install -y binutils
COPY --from=unstripped /go/prometheus/prometheus .
CMD ["objdump", "-s", "/prometheus"]