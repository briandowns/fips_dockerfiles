FROM goboring/golang:1.13.9b4 as builder

RUN apt update && apt upgrade -y && \
    apt install -y ca-certificates git bash build-essential rsync
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -                             && \
    apt-get update                                                                                && \
    apt install -y --no-install-recommends nodejs yarn                                            && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    rm -rf /var/lib/apt/lists/*

ENV GO111MODULE=on
RUN git clone --depth=1  https://github.com/briandowns/prometheus.git
RUN cd prometheus && \
    make build

FROM alpine:latest

RUN apk --no-cache add binutils
COPY --from=builder /go/prometheus/\prometheus .

CMD ["objdump", "-s", "/prometheus"]
