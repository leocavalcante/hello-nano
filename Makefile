.PHONY: install
install: build
	docker run -d -p 3500:3500 --rm --name hello-nano hello-nano

.PHONY: build
build:
	docker buildx build -t hello-nano .

.PHONY: uninstall
uninstall:
	docker stop hello-nano

.PHONY: test
test:
	composer test
