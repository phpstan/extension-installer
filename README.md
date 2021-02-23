# PHPStan Extension Installer

[![Build](https://github.com/phpstan/extension-installer/workflows/Build/badge.svg)](https://github.com/phpstan/extension-installer/actions)
[![Latest Stable Version](https://poser.pugx.org/phpstan/extension-installer/v/stable)](https://packagist.org/packages/phpstan/extension-installer)
[![License](https://poser.pugx.org/phpstan/extension-installer/license)](https://packagist.org/packages/phpstan/extension-installer)

Composer plugin for automatic installation of [PHPStan](https://phpstan.org/) extensions.

# Motivation

```diff
diff --git a/phpstan.neon b/phpstan.neon
index db4e3df32e..2ca30fa20a 100644
--- a/phpstan.neon
+++ b/phpstan.neon
@@ -1,12 +1,3 @@
-includes:
-	- vendor/phpstan/phpstan-doctrine/extension.neon
-	- vendor/phpstan/phpstan-doctrine/rules.neon
-	- vendor/phpstan/phpstan-nette/extension.neon
-	- vendor/phpstan/phpstan-nette/rules.neon
-	- vendor/phpstan/phpstan-phpunit/extension.neon
-	- vendor/phpstan/phpstan-phpunit/rules.neon
-	- vendor/phpstan/phpstan-strict-rules/rules.neon
-
 parameters:
 	autoload_directories:
 		- %rootDir%/../../../build/SlevomatSniffs
diff --git a/composer.json b/composer.json
index 1b578dd624..f6ebf6e477 100644
--- a/composer.json
+++ b/composer.json
@@ -142,6 +142,7 @@
 		"jakub-onderka/php-parallel-lint": "1.0.0",
 		"justinrainbow/json-schema": "5.2.8",
 		"ondrejmirtes/mocktainer": "0.8",
+		"phpstan/extension-installer": "^1.0",
 		"phpstan/phpstan": "^0.11.7",
 		"phpstan/phpstan-doctrine": "^0.11.3",
 		"phpstan/phpstan-nette": "^0.11.1",
```

## Usage

```bash
composer require --dev phpstan/extension-installer
```

And that's it.

## Instructions for extension developers

It's best (but optional) to set the extension's composer package [type](https://getcomposer.org/doc/04-schema.md#type) to `phpstan-extension` for this plugin to be able to recognize it and to be [discoverable on Packagist](https://packagist.org/explore/?type=phpstan-extension).

Add `phpstan` key in the extension `composer.json`'s `extra` section:

```json
{
  "extra": {
    "phpstan": {
      "includes": [
        "extension.neon"
      ]
    }
  }
}
```

## Limitations

The extension installer depends on Composer script events, therefore you cannot use `--no-scripts` flag.

If you really need this, you can add this to your own `composer.json`:
```json
    "scripts": {
        "install-phpstan-extensions": "PHPStan\\ExtensionInstaller\\Plugin::process"
    }
```

Then you can install it manually with `composer run install-phpstan-extensions`.
