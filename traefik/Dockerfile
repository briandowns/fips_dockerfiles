ARG UBI_IMAGE=registry.access.redhat.com/ubi8/ubi:latest

FROM goboring/golang:1.14.1b4 as builder
RUN apt update                                   && \
    apt upgrade -y                               && \
    apt install -y apt-utils ca-certificates git    \
                   bash build-essential libc-bin    \
                   libc-pic libc-dev curl
RUN mkdir -p /usr/local/bin && \
    curl -fsSL -o /usr/local/bin/go-bindata https://github.com/containous/go-bindata/releases/download/v1.0.0/go-bindata  && \
    chmod +x /usr/local/bin/go-bindata

RUN git clone --depth=1 https://github.com/containous/traefik.git
RUN cd /go/traefik && \
    CGO_ENABLED=1 script/make.sh generate binary

FROM builder as strip
ARG SEARCH_KEY=boring
RUN go tool nm /go/traefik/bin/traefik > /traefik_symbol_table.txt && \
    grep ${SEARCH_KEY} traefik_symbol_table.txt                    && \
    cd /go/traefik                                                 && \
    CGO_ENABLED=1 script/make.sh generate binary

FROM ${UBI_IMAGE}
RUN yum update -y  && \
    yum upgrade -y && \
    yum install -y binutils file
COPY --from=strip /go/traefik/dist/traefik .
CMD ["objdump", "-s", "/traefik"]
