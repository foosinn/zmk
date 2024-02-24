UID := $(shell id -u)
IMAGE := zmkfirmware/zmk-build-arm:3.0
DOCKERCMD := sudo -g docker docker

all: build

up: start .west update

start:
	${DOCKERCMD} run -itd --name zmk -u $(UID) -v ${PWD}:${PWD} -w ${PWD} -e HOME=/tmp ${IMAGE} sleep infinity

.west:
	${DOCKERCMD} exec zmk west init || true
	${DOCKERCMD} exec zmk west init -m https://github.com/zephyrproject-rtos/zephyr --mr v3.0.0 zephyrproject || true

update:
	#${DOCKERCMD} exec -w ${PWD}/app zmk west update
	true

build:
	${DOCKERCMD} exec -w ${PWD}/app zmk west build -b nice_nano_v2 -- -DSHIELD=23treus
	until ls -d /run/media/stefan/NICENANO/; do sleep 1; done
	cp app/build/zephyr/zmk.uf2 /run/media/stefan/NICENANO/


down:
	${DOCKERCMD} rm -f zmk
