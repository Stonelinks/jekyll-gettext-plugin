#Jekyll gettext plugin

A quick and dirty i18n plugin for jekyll based on gettext and po files.  



A lot of inspiration taken from [jekyll-multiple-languages-plugin](https://github.com/screeninteraction/jekyll-multiple-languages-plugin), it was just a little overkill for my needs and I wasn't a fan of managing translations in yaml files.

## Installation

Add this line to your application's Gemfile:

    gem 'jekyll-gettext-plugin'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install jekyll-gettext-plugin

## Usage

###Examples

Have a look at the [examples](examples) folder.

###Configuration

Add the i18n configuration to your _config.yml:

```yaml	
languages: ["en", "ja"]
```

The first language in the array will be the default language.

Default configuration values:

```yaml
# the languages to look for
languages: ["en"]

# the name of the text domain.
# This is the name of the .pot and .po files.
text_domain: "website"

# the folder relative to the _config.yml
# where the translations are placed inside
translations_folder: "_i18n"

# the files that are ignored by jekyll.
# This variable is automatically filled to avoid build loops
exclude: ["_i18n/website.pot"]
```

###i18n

Create this folder structure in your Jekyll project as an example:

- _i18n/ja/website.po
- _i18n/en/website.po

To add a string to your site use one of these

```liquid	
---
translate: true
---

{% t key %}
or 
{% translate key %}
```
	
These are liquid tags. They will pick the correct string from the correct `website.po` file during compilation for that language, or add it if no translation exists so you can fill it in later.

All files with a `translate` field inside the yaml header are put in the folders of their languages.
Without the `translate` field they remain where they are as usual.

You can translate variables in the header like this:

```liquid	
---
translate:
  title: Main Page
---
```

All translations automatically turn up in the `_i18n/website.pot` file.
You can translate them using [Poedit](https://poedit.net/download).
Whenever you save the po file, a `jekyll serve` rebuilds the site.

Make sure all files are saved in UTF-8 encoding.

## Contributing

1. Fork it ( http://github.com/Stonelinks/jekyll-gettext-plugin/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
