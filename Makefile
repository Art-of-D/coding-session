APP=$(shell basename $(shell git remote get-url origin))
GHCR_REGISTRY=ghcr.io/Art-of-D
VERSION=$(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD)

LINUX_AMD64=linux_amd64
LINUX_ARM64=linux_arm64
WINDOWS=windows_amd64
WINDOWS_ARM64=windows_arm64
MACOS=darwin_amd64
MACOS_ARM64=darwin_arm64


build:
	@echo "Usage: make <platform>"
	@echo "Available platforms:"
	@echo "  linux    - Build for Linux (AMD64)"
	@echo "  linux_arm64    - Build for Linux (ARM64)"
	@echo "  windows  - Build for Windows (AMD64)"
	@echo "  windows_arm64  - Build for Windows (ARM64)"
	@echo "  darwin   - Build for macOS (AMD64)"
	@echo "  darwin_arm64   - Build for macOS (ARM64)"
	@exit 2

# Збирання для Linux (AMD64)
linux_amd64:
	CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o coding-session-1-${LINUX} -ldflags "-X=github.com/Art-of-D/coding-session-1/cmd.appVersion=${VERSION}"

# Збирання для Linux (ARM64)
linux_arm64:
	CGO_ENABLED=0 GOOS=linux GOARCH=arm64 go build -o coding-session-1-${LINUX_ARM64} -ldflags "-X=github.com/Art-of-D/coding-session-1/cmd.appVersion=${VERSION}"

# Збирання для Windows (AMD64)
windows_amd64:
	CGO_ENABLED=0 GOOS=windows GOARCH=amd64 go build -o coding-session-1-${WINDOWS} -ldflags "-X=github.com/Art-of-D/coding-session-1/cmd.appVersion=${VERSION}"

# Збирання для Windows (ARM64)
windows_arm64:
	CGO_ENABLED=0 GOOS=windows GOARCH=arm64 go build -o coding-session-1-${WINDOWS_ARM64} -ldflags "-X=github.com/Art-of-D/coding-session-1/cmd.appVersion=${VERSION}"

# Збирання для macOS (AMD64)
darwin_amd64:
	CGO_ENABLED=0 GOOS=darwin GOARCH=amd64 go build -o coding-session-1-${MACOS} -ldflags "-X=github.com/Art-of-D/coding-session-1/cmd.appVersion=${VERSION}"

# Збирання для macOS (ARM64)
darwin_arm64:
	CGO_ENABLED=0 GOOS=darwin GOARCH=arm64 go build -o coding-session-1-${MACOS_ARM64} -ldflags "-X=github.com/Art-of-D/coding-session-1/cmd.appVersion=${VERSION}"

format:
	gofmt -s -w ./

get:
	go get

lint:
	golint

text:
	go test -v

build: format
	CGO_ENABLED=0 GOOS=${TARGETOS}  GOARCH=${TARGETARCH} go build -v -o coding-session-1 -ldflags "-X="github.com/Art-of-D/coding-session-1/cmd.appVersion=${VERSION}

image:
	docker build . -t ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}

push:
	docker push ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}

clean:
	rm -rf coding-session-1