.PHONY: check
check: lint cs phpstan

.PHONY: lint
lint:
	php vendor/bin/parallel-lint --colors \
		src

.PHONY: cs
cs:
	composer install --working-dir build-cs && php build-cs/vendor/bin/phpcs

.PHONY: cs-fix
cs-fix:
	php build-cs/vendor/bin/phpcbf

.PHONY: phpstan
phpstan:
	php vendor/bin/phpstan analyse -l 7 -c phpstan.neon src
