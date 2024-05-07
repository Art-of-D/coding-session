ifeq '$(findstring ;,$(PATH))' ';'
    detected_OS := windows
	detected_arch := amd64
else
    detected_OS := $(shell uname | tr '[:upper:]' '[:lower:]' 2> /dev/null || echo Unknown)
    detected_OS := $(patsubst CYGWIN%,Cygwin,$(detected_OS))
    detected_OS := $(patsubst MSYS%,MSYS,$(detected_OS))
    detected_OS := $(patsubst MINGW%,MSYS,$(detected_OS))
	detected_arch := $(shell dpkg --print-architecture 2>/dev/null || amd64)
endif

#colors:
B = \033[1;94m#   BLUE
G = \033[1;92m#   GREEN
Y = \033[1;93m#   YELLOW
R = \033[1;31m#   RED
M = \033[1;95m#   MAGENTA
K = \033[K#       ERASE END OF LINE
D = \033[0m#      DEFAULT
A = \007#         BEEP

APP = $(shell basename $(shell git remote get-url origin))
GHCR_REGISTRY = ghcr.io/art-of-d
VERSION = $(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD)
IMAGE_ID := $(shell docker images --format='{{.ID}}' | head -1)
TARGETOS = ${detected_OS}
TARGETARCH = amd64


linux:
	$(MAKE) image TARGETOS=linux TARGETARCH=amd64

linux-arm:
	$(MAKE) image TARGETOS=linux TARGETARCH=arm64

windows:
	$(MAKE) image TARGETOS=windows TARGETARCH=amd64

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
	docker build . -t ${REGESTRY}/${APP}:${VERSION}-${detected_OS}-${TARGETARCH} --build-arg TARGETOS=${detected_OS} --build-arg TARGETARCH=${TARGETARCH}

build: format get
	@printf "$GDetected OS/ARCH: $R$(detected_OS)/$(detected_arch)$D\n"
	CGO_ENABLED=0 GOOS=$(detected_OS) GOARCH=$(detected_arch) go build -v -o kbot -ldflags "-X="github.com/Art-of-D/coding-session-1/cmd.appVersion=${VERSION}

push:
	docker push ${GHCR_REGISTRY}/${APP}:${VERSION}-${TARGETOS}-${TARGETARCH}

arm: format get
	@printf "$GTarget OS/ARCH: $R$(detected_OS)/arm$D\n"
	CGO_ENABLED=0 GOOS=$(detected_OS) GOARCH=arm go build -v -o kbot -ldflags "-X="github.com/vit-um/kbot/cmd.appVersion=${VERSION}
	docker build --build-arg name=arm -t ${REGESTRY}/${APP}:${VERSION}-$(detected_OS)-arm .

dive: image
	IMG1=$$(docker images -q | head -n 1); \
	CI=true docker run -ti --rm -v /var/run/docker.sock:/var/run/docker.sock wagoodman/dive --ci --lowestEfficiency=0.99 $${IMG1}; \
	IMG2=$$(docker images -q | sed -n 2p); \
	docker rmi $${IMG1}; \
	docker rmi $${IMG2}

clean:
	rm -rf coding-session-1; \
	IMG1=$$(docker images -q | head -n 1); \
	if [ -n "$${IMG1}" ]; then  docker rmi -f $${IMG1}; else printf "$RImage not found$D\n"; fi

