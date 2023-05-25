.PHONY: check
check: lint cs phpstan

.PHONY: lint
lint:
	php vendor/bin/parallel-lint --colors \
		src

.PHONY: cs-install
cs-install:
	git clone https://github.com/phpstan/build-cs.git || true
	git -C build-cs fetch origin && git -C build-cs reset --hard origin/main
	composer install --working-dir build-cs

.PHONY: cs
cs:
	php build-cs/vendor/bin/phpcs --standard=build-cs/phpcs.xml src

.PHONY: cs-fix
cs-fix:
	php build-cs/vendor/bin/phpcbf --standard=build-cs/phpcs.xml src

.PHONY: phpstan
phpstan:
	php vendor/bin/phpstan
