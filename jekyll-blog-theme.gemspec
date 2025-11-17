# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name          = "jekyll-blog-theme"
  spec.version       = "0.1.0"
  spec.authors       = ["Your Name"]
  spec.email         = ["your.email@example.com"]

  spec.summary       = "A minimal, clean Jekyll theme for blogs"
  spec.description   = "A minimal, clean Jekyll theme inspired by Daily Thoughts blog with support for posts, tags, pagination, and archive pages."
  spec.homepage      = "https://github.com/yourusername/jekyll-blog-theme"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").select do |f|
    f.match(%r{^(assets|_layouts|_includes|_sass|LICENSE|README|_config\.yml)}i)
  end

  spec.required_ruby_version = ">= 2.6.0"

  spec.add_runtime_dependency "jekyll", "~> 4.3"
  spec.add_runtime_dependency "jekyll-feed", "~> 0.12"
  spec.add_runtime_dependency "jekyll-seo-tag", "~> 2.6"
  spec.add_runtime_dependency "jekyll-paginate", "~> 1.1"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
end
