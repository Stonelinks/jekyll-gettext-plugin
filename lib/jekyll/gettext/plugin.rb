require "jekyll/gettext/plugin/version"

require 'fast_gettext'
require 'get_pomo'

module Jekyll
  class Site
    
    alias :process_org :process
    def process
      if !self.config['baseurl']
        self.config['baseurl'] = ""
      end
      # variables
      config['baseurl_root'] = self.config['baseurl']
      baseurl_org = self.config['baseurl']
      languages = self.config['languages']
      dest_org = self.dest

      # loop
      self.config['lang'] = languages.first
      puts
      puts "Building site for default language: \"#{self.config['lang']}\" to: " + self.dest
      process_org
      languages.drop(1).each do |lang|

        # build site for language lang
        self.dest = self.dest + "/" + lang
        self.config['baseurl'] = self.config['baseurl'] + "/" + lang
        self.config['lang'] = lang
        puts "Building site for language: \"#{self.config['lang']}\" to: " + self.dest
        process_org

        # reset variables for next language
        self.dest = dest_org
        self.config['baseurl'] = baseurl_org
      end
      puts 'Build complete'
    end
    

    # TODO:
    # parse the yaml file and store it in site whenever lang changes
    # if a key is missing, add it to a list on site
    # when site is done processing, write back to master yaml file

    def load_translations
      unless I18n::backend.instance_variable_get(:@translations)
        I18n.backend.load_translations Dir[File.join(File.dirname(__FILE__),'../_locales/*.yml')]
        I18n.locale = LOCALE
      end
    end
  end

  class LocalizeTag < Liquid::Tag

    def initialize(tag_name, key, tokens)
      super
      @key = key.strip
    end

    def render(context)
      if "#{context[@key]}" != "" # check for page variable
        key = "#{context[@key]}"
      else
        key = @key
      end
      lang = context.registers[:site].config['lang']
      candidate = YAML.load_file(context.registers[:site].source + "/_i18n/#{lang}.yml")
      path = key.split(/\./) if key.is_a?(String)
      while !path.empty?
        key = path.shift
        if candidate[key]
          candidate = candidate[key]
        else
          candidate = ""
        end
      end
      if candidate == ""
        puts "Missing i18n key: " + lang + ":" + key
        "*" + lang + ":" + key + "*"
      else
        candidate
      end
    end
  end
end

Liquid::Template.register_tag('t', Jekyll::LocalizeTag)
Liquid::Template.register_tag('translate', Jekyll::LocalizeTag)
