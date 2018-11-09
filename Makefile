# This file is used to manage local images
# depending of the current dir and branch.
# Branch 'master' leads to no tag (=latest),
# others to "local/[dirname]:[branchname]

# run 'make echo' to show the image name you're working on.

TAG = 20181109

REPO = krausm/$(shell basename `pwd`)
IMAGE=$(REPO):$(TAG)

.PHONY: build bash start start_vol echo site

build:
	docker build -t $(IMAGE) .
	docker images | grep '$(REPO)'
start:
	docker run -it --rm -p 80:80 -p 443:443 $(IMAGE)
start_vol:
	docker run -it --rm -p 80:80 -p 443:443 -p 8086:8086 -v $(shell pwd)/site/local:/omd/sites/demo/local -v $(shell pwd)/site/etc:/omd/sites/demo/etc -v $(shell pwd)/site/var:/omd/sites/demo/var $(IMAGE)
echo:
	echo $(IMAGE)
bash:
	docker run --rm -p 80:80 -p 443:443 -it $(IMAGE) /bin/bash
site:
	mkdir -p $(shell pwd)/site/local
	mkdir -p $(shell pwd)/site/etc
	mkdir -p $(shell pwd)/site/var
