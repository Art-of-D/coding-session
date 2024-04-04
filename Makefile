APP=$(shell basename $(shell git remote get-url origin))
GHCR_REGISTRY=ghcr.io/art-of-d
VERSION=$(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD)

linux:
	$(MAKE) image TARGETOS=linux TARGETARCH=amd64

linux-arm:
	$(MAKE) image TARGETOS=linux TARGETARCH=arm64

windows:
	$(MAKE) image TARGETOS=windows TARGETARCH=TARGETARCH

windows-arm:
	$(MAKE) image TARGETOS=windows TARGETARCH=arm64

macos:
	$(MAKE) image TARGETOS=darwin TARGETARCH=amd64

macos-arm:
	$(MAKE) image TARGETOS=darwin TARGETARCH=arm64

format:
	gofmt -s -w ./

get:
	go get

lint:
	golint

test:
	go test -v

image:
	docker build . -t ${GHCR_REGISTRY}/${APP}:${VERSION}-${TARGETOS}-${TARGETARCH}

build: format get
	CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -v -o coding-session-1 -ldflags "-X"=github.com/Art-of-D/coding-session-1/cmd.appVersion=${VERSION}

push:
	docker push ${GHCR_REGISTRY}/${APP}:${VERSION}-${TARGETARCH}

clean:
	rm -rf coding-session-1
	docker rmi -f ${GHCR_REGISTRY}/${APP}:${VERSION}-linux-amd64
	docker rmi -f ${GHCR_REGISTRY}/${APP}:${VERSION}-linux-arm64
	docker rmi -f ${GHCR_REGISTRY}/${APP}:${VERSION}-windows-amd64
	docker rmi -f ${GHCR_REGISTRY}/${APP}:${VERSION}-windows-arm64
	docker rmi -f ${GHCR_REGISTRY}/${APP}:${VERSION}-darwin-amd64
	docker rmi -f ${GHCR_REGISTRY}/${APP}:${VERSION}-darwin-arm64

