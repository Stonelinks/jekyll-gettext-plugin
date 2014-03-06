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


###Configuration
Add the i18n configuration to your _config.yml:

```yaml	
languages: ["ja", "en", "ja"]
```

The first language in the array will be the default language, Japanese and English will be added in to separate subfolders.

###i18n
Create this folder structure in your Jekyll project as an example:

- _i18n/ja/ja.po
- _i18n/en/en.po

To add a string to your site use one of these

```liquid	
{% t key %}
or 
{% translate key %}
```
	
Liquid tags. This will pick the correct string from the `language.po` file during compilation, or add it if no translation exists so you can fill it in later.

## Contributing

1. Fork it ( http://github.com/Stonelinks/jekyll-gettext-plugin/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
