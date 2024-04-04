FROM golang:1.22 as builder

WORKDIR /go/src/app
COPY . .
ARG TARGETOS
ARG TARGETARCH
RUN make build  TARGETOS=${TARGETOS} TARGETARCH=${TARGETARCH}

FROM scratch
WORKDIR /
COPY --from=builder /go/src/app/coding-session-1 .
COPY --from=alpine:latest /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
ENTRYPOINT [ "./coding-session-1" ]
