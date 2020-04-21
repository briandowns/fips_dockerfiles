ARG UBI_IMAGE=registry.access.redhat.com/ubi7/ubi-minimal:latest

FROM goboring/golang:1.13.9b4 as builder
RUN apt update                                      && \
    apt upgrade -y                                  && \
    apt install -y apt-transport-https ca-certificates \
                   software-properties-common git      \
                   curl bash
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add                                    && \
    add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable" && \
    apt update                                                                                               && \
    apt install -y docker-ce docker-ce-cli containerd.io                                                     && \
    rm -rf /var/lib/apt/lists/*
RUN curl https://glide.sh/get | sh

RUN git clone --depth=1 https://github.com/projectcalico/calico.git
RUN cd /go/calico && \
    CGO_ENABLED=1 make build-all

FROM ${UBI_IMAGE}
RUN microdnf update -y && \
    rm -rf /var/cache/yum

COPY --from=builder /go/calico/bin /usr/local/bin
