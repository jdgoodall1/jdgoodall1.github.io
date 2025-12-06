source "https://rubygems.org"

# GitHub Pages gem - includes Jekyll and all supported plugins
gem "github-pages", group: :jekyll_plugins

# Additional Jekyll plugins (all GitHub Pages compatible)
group :jekyll_plugins do
  gem "jekyll-feed"
  gem "jekyll-seo-tag"
  gem "jekyll-sitemap"
  gem "jekyll-paginate"
end

# Testing dependencies
group :test do
  gem "rspec", "~> 3.12"
  gem "rantly", "~> 2.0"  # Property-based testing
  gem "html-proofer", "~> 5.0"  # HTML validation
end

# Development dependencies
group :development do
  gem "webrick", "~> 1.8"  # Required for Ruby 3.0+
end
