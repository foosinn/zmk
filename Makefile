UID := $(shell id -u)
IMAGE := zmkfirmware/zmk-build-arm:3.0
DOCKERCMD := sudo -g docker docker

all: build

up: .west update
	${DOCKERCMD} run -itd --name zmk -u $(UID) -v ${PWD}:${PWD} -w ${PWD} -e HOME=/tmp ${IMAGE} sleep infinity


.west:
	${DOCKERCMD} exec zmk west init || true

update:
	${DOCKERCMD} exec -w ${PWD}/app zmk west update

build:
	${DOCKERCMD} exec -w ${PWD}/app zmk west build -b nice_nano_v2 -- -DSHIELD=23treus


down:
	${DOCKERCMD} rm -f zmk
