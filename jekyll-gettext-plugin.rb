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
    
    alias :read_posts_org :read_posts
    def read_posts(dir)
      if dir == ''
        read_posts("_i18n/#{self.config['lang']}/")
      else
        read_posts_org(dir)
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
