# PHPStan Extension Installer

Composer plugin for automatic installation of [PHPStan](https://github.com/phpstan/phpstan) extensions.

## Usage

```bash
composer require --dev phpstan/extension-installer
```

And that's it.

## Extension usage & features

Extension's composer package [type](https://getcomposer.org/doc/04-schema.md#type) has to be set to `phpstan-extension` for this plugin to be able to recognize it.

Only one feature is supported right now: PHPStan is able to automatically include the extension's config files, without you having to mention them in your `phpstan.neon`'s `includes` section.

For this, you have to add a `phpstan` key in the extension `composer.json`'s `extra` section like so: 

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
