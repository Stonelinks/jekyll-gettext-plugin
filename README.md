# Jekyll::Gettext::Plugin

A quick and dirty i18n plugin for jekyll based on gettext and po files  

Inspiration taken from [jekyll-multiple-languages-plugin](https://github.com/screeninteraction/jekyll-multiple-languages-plugin), it was just a little overkill for my needs and I wasn't a fan of managing translations in yaml files.

## Installation

Add this line to your application's Gemfile:

    gem 'jekyll-gettext-plugin'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install jekyll-gettext-plugin

## Usage

- In _config.yml, add a languages array where the first one is your primary language, for example `languages: ["ja", "ja", "en"]`
- For each language, make sure there is a po file in `_i18n/<LANG>/<LANG>.po`. So if you're doing japanese translations for the first time you'd do something like `mkdir -p _i18n/ja && touch _i18n/ja/ja.po`
- Use tags that look like this {% t hey there! %} in your web pages
- Any time jekyll builds, the plugin will add any new keys to the po file. Fill these in and rebuild to see the translated website. Each translated website is served at a url relative to that language, IE `http://localhost:8080/ja/`, `http://localhost:8080/en/`, etc.

## Contributing

1. Fork it ( http://github.com/Stonelinks/jekyll-gettext-plugin/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
