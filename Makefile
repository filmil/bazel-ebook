CONTAINER_NAME := ebook-buildenv:latest

DOCKER_RUN := docker run -it \
			-u $(shell id -u):$(shell id -g) \
			-v "$(shell pwd):/opt/book" \
			-w /opt/book \
			${CONTAINER_NAME} \

run: build
	$(info run: scons)
	@${DOCKER_RUN} scons

clean:
	$(info run: scons -c)
	@${DOCKER_RUN} scons -c
	
build:
	docker build -t ${CONTAINER_NAME} docker/

