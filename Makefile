APP=$(shell basename $(shell git remote get-url origin))
GHCR_REGISTRY=ghcr.io/art-of-d
VERSION=$(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD)

info:
	@echo "Usage: make <platform>"
	@echo "Available platforms:"
	@echo "  linux          - Build for Linux (AMD64)"
	@echo "  linux-arm64    - Build for Linux (ARM64)"
	@echo "  windows        - Build for Windows (AMD64)"
	@echo "  windows-arm64  - Build for Windows (ARM64)"
	@echo "  macos         - Build for macOS (AMD64)"
	@echo "  macos-arm64   - Build for macOS (ARM64)"

linux:
	@echo "Building for Linux (AMD64)"
	@$(MAKE) image TARGETOS=linux TARGETARCH=amd64

linux-arm64:
	@echo "Building for Linux (ARM64)"
	@$(MAKE) image TARGETOS=linux TARGETARCH=arm64

macos:
	@echo "Building for macOS (AMD64)"
	@$(MAKE) image TARGETOS=darwin TARGETARCH=amd64

macos-arm64:
	@echo "Building for macOS (ARM64)"
	@$(MAKE) image TARGETOS=darwin TARGETARCH=arm64

windows:
	@echo "Building for Windows (AMD64)"
	@$(MAKE) image TARGETOS=windows TARGETARCH=amd64

windows-arm64:
	@echo "Building for Windows (ARM64)"
	@$(MAKE) image TARGETOS=windows TARGETARCH=arm64
	

format:
	gofmt -s -w ./

get:
	go get

lint:
	golint

text:
	go test -v

image:
	docker build . -t ${GHCR_REGISTRY}/${APP}:${VERSION}-${TARGETOS}-${TARGETARCH}

build:
	CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -o coding-session-1 -ldflags "-X=github.com/Art-of-D/coding-session-1/cmd.appVersion=${VERSION}"

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

