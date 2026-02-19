# CLAUDE.md

## Project Overview

**phpstan/extension-installer** is a Composer plugin that automatically registers PHPStan extensions. Without it, users must manually add `includes` entries in their `phpstan.neon` for every installed PHPStan extension. This plugin detects installed extensions and generates a configuration file so PHPStan picks them up automatically.

The package is published as `phpstan/extension-installer` on Packagist with the Composer type `composer-plugin`.

## How It Works

1. The plugin (`src/Plugin.php`) subscribes to Composer's `post-install-cmd` and `post-update-cmd` script events.
2. On each event, it scans all installed packages for PHPStan extensions (packages with type `phpstan-extension` or an `extra.phpstan` key in their `composer.json`).
3. It generates `src/GeneratedConfig.php` containing a constant with all discovered extensions, their install paths, and included neon files.
4. PHPStan reads `GeneratedConfig.php` at runtime to load the extensions automatically.
5. A stub `GeneratedConfig.php` is committed to the repo as a fallback for when Composer runs with `--no-scripts`.

Users can ignore specific extensions via `extra.phpstan/extension-installer.ignore` in their project's `composer.json`.

## Repository Structure

```
src/
  Plugin.php           - The Composer plugin (event subscriber, extension discovery, config generation)
  GeneratedConfig.php  - Stub file (overwritten at install time with discovered extensions)
e2e/
  integration/         - E2E test: installs phpstan-phpunit extension, runs PHPStan analysis
  ignore/              - E2E test: verifies the ignore functionality works correctly
  test-extension/      - Minimal test extension used by the ignore e2e test
.github/workflows/
  build.yml            - Lint, coding standard, and PHPStan static analysis
  integration-tests.yml - E2E integration and ignore tests across PHP/Composer versions
```

## PHP Version Support

This repository supports **PHP 7.4+** (see `composer.json`: `"php": "^7.4 || ^8.0"`). Do not use language features unavailable in PHP 7.4.

## Dependencies

- `composer-plugin-api: ^2.0` - Composer 2.x plugin API
- `phpstan/phpstan: ^2.0` - PHPStan (dev dependency for self-analysis; the plugin itself works with extensions requiring PHPStan ^1 or ^2)

Dev dependencies:
- `composer/composer: ^2.0` - For type information
- `php-parallel-lint/php-parallel-lint: ^1.2.0` - Syntax linting
- `phpstan/phpstan-strict-rules: ^2.0` - Strict PHPStan rules for self-analysis

## Development Commands

All commands are defined in the `Makefile`:

```bash
make check       # Run all checks (lint + cs + phpstan)
make lint         # Run php-parallel-lint on src/
make cs           # Run PHP_CodeSniffer (requires build-cs to be set up)
make cs-install   # Clone and install phpstan/build-cs coding standard
make cs-fix       # Auto-fix coding standard violations
make phpstan      # Run PHPStan static analysis (level 8)
```

### Coding Standard

This project uses [phpstan/build-cs](https://github.com/phpstan/build-cs) (branch `2.x`) for coding standards via PHP_CodeSniffer. The `phpcs.xml` configures `php_version` as `70400` (PHP 7.4). To set it up locally:

```bash
make cs-install
make cs
```

### Static Analysis

PHPStan runs at **level 8** on the `src/` directory with `phpstan-strict-rules` included. Configuration is in `phpstan.neon`.

## CI Pipeline

### Build (`build.yml`)

- **Lint**: Runs `php-parallel-lint` across PHP 7.4, 8.0, 8.1, 8.2, 8.3, 8.4
- **Coding Standard**: Runs PHP_CodeSniffer on PHP 8.2
- **PHPStan**: Runs static analysis across PHP 7.4-8.4 with both lowest and highest dependency versions

### Integration Tests (`integration-tests.yml`)

- **Integration test**: Installs `phpstan-phpunit` via the extension installer, runs PHPStan analysis on a test file, then verifies it works after renaming the directory (testing relative path handling)
- **Ignore test**: Verifies the ignore configuration correctly excludes specified extensions
- Both tests run across PHP 7.4-8.5 and multiple Composer versions (v2, preview, snapshot, 2.1.0)
- Uses `COMPOSER_ROOT_VERSION: "1.4.x-dev"` environment variable

## Branch

The main development branch is `1.4.x`.

## Making Changes

- Keep `src/GeneratedConfig.php` as a stub - it gets overwritten at install time by `Plugin.php`.
- Any changes to the plugin logic are in `src/Plugin.php`.
- E2E tests in `e2e/` validate the plugin works end-to-end with real Composer installs.
- Run `make check` before submitting changes to verify lint, coding standard, and static analysis all pass.
