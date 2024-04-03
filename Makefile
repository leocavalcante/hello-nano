.PHONY: start
start: install
	@composer start

.PHONY: install
install:
	@composer install

.PHONY: test
test:
	@composer test

.PHONY: update
update:
	@composer update
