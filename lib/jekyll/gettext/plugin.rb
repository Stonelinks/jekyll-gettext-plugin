require "jekyll/gettext/plugin/version"

require 'fast_gettext'
require 'get_pomo'

require 'pry'

class MissingTranslationLogger
  def initialize
    @translations = []
  end
  
  def get_translations
    return @translations
  end
  
  def call(unfound)
    @translations.push(unfound)
  end
end


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
      self.load_translations
      process_org
      self.save_missing_translations
      
      languages.drop(1).each do |lang|

        # build site for language lang
        self.dest = self.dest + "/" + lang
        self.config['baseurl'] = self.config['baseurl'] + "/" + lang
        self.config['lang'] = lang
        puts "Building site for language: \"#{self.config['lang']}\" to: " + self.dest
        self.load_translations
        process_org
        self.save_missing_translations

        # reset variables for next language
        self.dest = dest_org
        self.config['baseurl'] = baseurl_org
      end
      puts 'Build complete'
    end

    def load_translations
      FastGettext.add_text_domain(self.config['lang'], :path => self.source + "/_i18n", :type => :po, :ignore_fuzzy => false)
      FastGettext.text_domain = self.config['lang']
      FastGettext.locale = self.config['lang']

      @missing_translations = MissingTranslationLogger.new

      repos = [
        FastGettext::TranslationRepository.build('logger', :type=>:logger, :callback=>lambda{|_|}),
        FastGettext::TranslationRepository.build('logger', :type=>:logger, :callback=>@missing_translations)
      ]
      FastGettext.add_text_domain(self.config['lang'], :type=>:chain, :chain=>repos)
    end

    def save_missing_translations
      filename = self.source + "/_i18n/" + self.config['lang'] + '/' + self.config['lang'] + '.po'
      existing_translations = GetPomo.unique_translations(GetPomo::PoFile.parse(File.read(filename)))
      
      # ignores any keys that already exist
      missing_translations_msgids = @missing_translations.get_translations.reject{|msgid| existing_translations.find{|trans| trans.msgid == msgid}}
      
      new_translations = existing_translations
      
      missing_translations_msgids.each do |new_msgid|
        new_trans = GetPomo::Translation.new
        new_trans.msgid = new_msgid
        new_trans.msgstr = ""
        new_translations.push(new_trans)
      end
      new_translations.sort_by!(&:msgid)

      File.open(filename + '.test', 'w'){|f|f.print(GetPomo::PoFile.to_text(new_translations))}
    end
  end

  class LocalizeTag < Liquid::Tag
    include FastGettext::Translation

    def initialize(tag_name, key, tokens)
      super
      @key = key.strip
    end

    def render(context)
      return _(@key)
    end
  end
end

Liquid::Template.register_tag('t', Jekyll::LocalizeTag)
Liquid::Template.register_tag('translate', Jekyll::LocalizeTag)
