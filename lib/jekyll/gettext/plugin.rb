require "jekyll/gettext/plugin/version"

require 'fast_gettext'
require 'get_pomo'

# require 'pry'

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
      self.load_translations
      puts
      puts "Building site for default language: \"#{self.config['lang']}\" to: " + self.dest
      process_org
      languages.drop(1).each do |lang|

        # build site for language lang
        self.dest = self.dest + "/" + lang
        self.config['baseurl'] = self.config['baseurl'] + "/" + lang
        self.config['lang'] = lang
        self.load_translations
        puts "Building site for language: \"#{self.config['lang']}\" to: " + self.dest
        process_org

        # reset variables for next language
        self.dest = dest_org
        self.config['baseurl'] = baseurl_org
      end
      puts 'Build complete'
    end

    # TODO:
    # parse the po file and store it in site whenever lang changes
    # if a key is missing, add it to a list on site object
    # when site is done processing, write back to po file

    def load_translations
      FastGettext.add_text_domain(self.config['lang'], :path => self.source + "/_i18n", :type => :po)
      FastGettext.text_domain = self.config['lang']
      FastGettext.locale = self.config['lang']
    end
  end

  class LocalizeTag < Liquid::Tag
    include FastGettext::Translation

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
      candidate = _(key)

      # binding.pry

      lang = context.registers[:site].config['lang']

      if candidate == key and lang != 'en'
        puts "Missing i18n key: " + lang + ":" + key
        "*" + lang + ":" + key + "*"
      end
      candidate
    end
  end
end

Liquid::Template.register_tag('t', Jekyll::LocalizeTag)
Liquid::Template.register_tag('translate', Jekyll::LocalizeTag)
