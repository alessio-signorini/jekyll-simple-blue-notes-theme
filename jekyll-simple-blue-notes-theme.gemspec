# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name          = "jekyll-simple-blue-notes-theme"
  spec.version       = "0.1.0"
  spec.authors       = ["Alessio Signorini"]
  spec.email         = ["alessio@signorini.us"]

  spec.summary       = "A minimal, clean Jekyll theme for notes and blogs"
  spec.description   = "A simple Jekyll theme designed for personal notes and blogs, has an archive, tags, and a clean layout inspired by the simplicity of Tumblr's old themes."
  spec.homepage      = "https://github.com/yourusername/jekyll-blog-theme"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").select do |f|
    f.match(%r{^(assets|_layouts|_includes|_sass|LICENSE|README|_config\.yml)}i)
  end

  spec.required_ruby_version = ">= 2.6.0"

  spec.add_runtime_dependency "jekyll", "~> 3.9.3"
  spec.add_runtime_dependency "jekyll-feed"
  spec.add_runtime_dependency "jekyll-seo-tag"
  spec.add_runtime_dependency "jekyll-sitemap"
  spec.add_runtime_dependency "jekyll-redirect-from"
  spec.add_runtime_dependency "jekyll-sass-converter"
  spec.add_runtime_dependency "rouge"
  spec.add_runtime_dependency "kramdown-parser-gfm"
 
  spec.add_development_dependency "webrick"
  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
end
