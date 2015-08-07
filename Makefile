REPOSITORY=mvanholsteijn/ecs-bug
REV=$$(git rev-parse --short HEAD)
REPREV=$(REPOSITORY):$(REV)
CLUSTER=consul-with-router-on-ecs

test:
	./runtask.sh $(CLUSTER) test-noarg
	./runtask.sh $(CLUSTER) test-witharg
	./runtask.sh $(CLUSTER) test-withentrypoint
	./runtask.sh $(CLUSTER) test-ep-and-arg
	
build: 
	docker build --no-cache --force-rm -t $(REPREV) .
	docker tag  -f $(REPREV) $(REPOSITORY):latest
	@echo $(REPREV)

release: build
	@[ -z "$$(git status -s)" ] || (echo "outstanding changes" ; git status -s && exit 1)
	docker push $(REPREV)
	docker push $(REPOSITORY):latest


