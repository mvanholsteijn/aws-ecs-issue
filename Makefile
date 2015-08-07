REPOSITORY=mvanholsteijn/ecs-bug
REV=$$(git rev-parse --short HEAD)
REPREV=$(REPOSITORY):$(REV)
CLUSTER=consul-with-router-on-ecs

build: 
	docker build --no-cache --force-rm -t $(REPREV) .
	docker tag  -f $(REPREV) $(REPOSITORY):latest
	@echo $(REPREV)

release: build
	@[ -z "$$(git status -s)" ] || (echo "outstanding changes" ; git status -s && exit 1)
	docker push $(REPREV)
	docker push $(REPOSITORY):latest


