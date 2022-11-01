CONTAINER_CMD ?= nerdctl
GITHUB_TOKEN ?= ${GITHUB_API_TOKEN}

.PHONY: default
default: container init build

.PHONY: container
container:
	DOCKER_BUILDKIT=1 ${CONTAINER_CMD} build -f Containerfile --tag pi-packer:latest .

.PHONY: pre
pre:
	@mkdir -p .packer.d/cache images
	@mkdir -p images

.PHONY: init
init: pre
	${CONTAINER_CMD} run \
		--volume="${CURDIR}":/workspace:ro \
		--volume="${CURDIR}/.packer.d":/workspace/.packer.d:rw \
		--privileged \
		pi-packer:latest \
		init ./packer

.PHONY: build
build: pre
	@rm -rf images
	@mkdir images
	${CONTAINER_CMD} run \
		--volume="${CURDIR}":/workspace:ro \
		--volume="${CURDIR}/images":/workspace/images:rw \
		--volume="${CURDIR}/.packer.d":/workspace/.packer.d:rw \
		--env=PKR_VAR_github_token=${GITHUB_TOKEN} \
		--volume=/dev:/dev \
		--privileged \
		pi-packer:latest \
		build -on-error=ask ./packer ${PACKER_EXCEPT}
	xz --compress --keep --threads=0 ./images/*.img

.PHONY: clean
clean:
	@rm -rf images
	@rm -rf .packer.d/cache
