
ifeq ($(TARGET),rhel)
  DOCKERFILE := Dockerfile.rhel
  REPOSITORY := openshiftio/rhel-bayesian-gremlin
else
  DOCKERFILE := Dockerfile
  REPOSITORY := openshiftio/bayesian-gremlin
endif

REGISTRY := quay.io
DEFAULT_TAG=latest

.PHONY: all docker-build fast-docker-build get-image-name get-image-repository

all: fast-docker-build

docker-build:
	docker build --no-cache -t $(REGISTRY)/$(REPOSITORY):$(DEFAULT_TAG) -f $(DOCKERFILE) .

fast-docker-build:
	docker build -t $(REGISTRY)/$(REPOSITORY):$(DEFAULT_TAG) -f $(DOCKERFILE) .

get-image-name:
	@echo $(REGISTRY)/$(REPOSITORY):$(DEFAULT_TAG)

get-image-repository:
	@echo $(REPOSITORY)

get-push-registry:
	@echo $(REGISTRY)
