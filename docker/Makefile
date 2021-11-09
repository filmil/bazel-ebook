# OK this is a bit embarrassing, but I still don't quite understand how to
# build Docker containers through Bazel.

REMOTE_CONTAINER=filipfilmar/ebook-buildenv:1.1

build:
	docker build -t ebook-buildenv:local .
.PHONY: build

tag: build
	docker tag ebook-buildenv:local ${REMOTE_CONTAINER} 
.PHONY: tag

push: tag
	docker push ${REMOTE_CONTAINER}
.PHONY: push
