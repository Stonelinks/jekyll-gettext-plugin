# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'jekyll/gettext/plugin/version'

Gem::Specification.new do |spec|
  spec.name          = "jekyll-gettext-plugin"
  spec.version       = Jekyll::Gettext::Plugin::VERSION
  spec.authors       = ["Lucas Doyle"]
  spec.email         = ["lucas.p.doyle@gmail.com"]
  spec.summary       = %q{A quick and dirty i18n plugin for jekyll based on gettext and po files}
  spec.homepage      = "https://github.com/Stonelinks/jekyll-gettext-plugin"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "fast_gettext", "~> 0.8"
  spec.add_runtime_dependency "get_pomo", "~> 0.6"

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "pry"
end
