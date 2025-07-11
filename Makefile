UID := $(shell id -u)
IMAGE := zmkfirmware/zmk-build-arm:3.5
DOCKERCMD := sudo -g docker docker

all: build

up: down start .west update

down:
	${DOCKERCMD} rm -f zmk

clean:
	rm -rf app/build/

start:
	${DOCKERCMD} run -itd --network=host --name zmk -u $(UID) -v ${PWD}:${PWD} -w ${PWD} -e HOME=/tmp ${IMAGE} sleep infinity

.west:
	${DOCKERCMD} exec zmk west init -l app || true

update:
	${DOCKERCMD} exec -w ${PWD}/app zmk west update
	true

buildclean: clean build

build:
	${DOCKERCMD} exec -w ${PWD}/app zmk west build -b nice_nano_v2 -S zmk-usb-logging -- -DSHIELD=23treus
	until ls -d /run/media/stefan/NICENANO/; do sleep 1; done
	cp app/build/zephyr/zmk.uf2 /run/media/stefan/NICENANO/

build2040:
	${DOCKERCMD} exec -w ${PWD}/app zmk west build -b sparkfun_pro_micro_rp2040 -S zmk-usb-logging -- -DSHIELD=23treus
	until ls -d /run/media/stefan/RPI-RP2/; do sleep 1; done
	cp app/build/zephyr/zmk.uf2 /run/media/stefan/RPI-RP2/

down:
	${DOCKERCMD} rm -f zmk
