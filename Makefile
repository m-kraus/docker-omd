# This file is used to manage local images
# depending of the current dir and branch.
# Branch 'master' leads to no tag (=latest),
# others to "local/[dirname]:[branchname]

# run 'make echo' to show the image name you're working on.

TAG = 20170128

REPO = local/$(shell basename `pwd`)
IMAGE=$(REPO):$(TAG)

.PHONY: build bash start start_vol

build:
	docker build -t $(IMAGE) .
	docker images | grep '$(REPO)'
start:
	docker run -it --rm -p 80:80 -p 443:443 $(IMAGE)
start_conf:
	docker run -it --rm -p 80:80 -p 443:443 -v $(shell pwd)/etc:/omd/sites/demo/etc $(IMAGE)
start_full:
	docker run -it --rm -p 80:80 -p 443:443 -v $(shell pwd)/etc:/omd/sites/demo/etc -v $(shell pwd)/var:/omd/sites/demo/var $(IMAGE)
echo:
	echo $(IMAGE)
bash:
	docker run --rm -p 80:80 -p 443:443 -it $(IMAGE) /bin/bash
