#!/usr/bin/env ruby
# Simple configuration validator that can be run without RSpec
# This validates the same properties as the full property test

require 'yaml'

# GitHub Pages supported plugins whitelist
GITHUB_PAGES_PLUGINS = [
  'jekyll-coffeescript',
  'jekyll-commonmark-ghpages',
  'jekyll-gist',
  'jekyll-github-metadata',
  'jekyll-paginate',
  'jekyll-relative-links',
  'jekyll-optional-front-matter',
  'jekyll-readme-index',
  'jekyll-default-layout',
  'jekyll-titles-from-headings',
  'jekyll-feed',
  'jekyll-seo-tag',
  'jekyll-sitemap',
  'jekyll-avatar',
  'jekyll-mentions',
  'jekyll-redirect-from',
  'jekyll-remote-theme',
  'jekyll-include-cache',
  'jemoji'
].freeze

def validate_config
  config_file = '_config.yml'
  
  unless File.exist?(config_file)
    puts "❌ ERROR: #{config_file} does not exist"
    return false
  end
  
  begin
    config = YAML.load_file(config_file)
  rescue => e
    puts "❌ ERROR: Failed to parse #{config_file}: #{e.message}"
    return false
  end
  
  unless config.key?('plugins')
    puts "❌ ERROR: 'plugins' key not found in #{config_file}"
    return false
  end
  
  plugins = config['plugins']
  
  unless plugins.is_a?(Array)
    puts "❌ ERROR: 'plugins' should be an array"
    return false
  end
  
  # Check for duplicates
  if plugins.uniq.length != plugins.length
    duplicates = plugins.group_by(&:itself).select { |k, v| v.size > 1 }.keys
    puts "❌ ERROR: Duplicate plugins found: #{duplicates.join(', ')}"
    return false
  end
  
  # Validate each plugin is in whitelist
  invalid_plugins = []
  plugins.each do |plugin|
    unless GITHUB_PAGES_PLUGINS.include?(plugin)
      invalid_plugins << plugin
    end
  end
  
  if invalid_plugins.any?
    puts "❌ ERROR: The following plugins are not supported by GitHub Pages:"
    invalid_plugins.each { |p| puts "  - #{p}" }
    puts "\nSupported plugins:"
    GITHUB_PAGES_PLUGINS.each { |p| puts "  - #{p}" }
    return false
  end
  
  # Check required plugins
  required_plugins = ['jekyll-feed', 'jekyll-seo-tag', 'jekyll-sitemap', 'jekyll-paginate']
  missing_plugins = required_plugins - plugins
  
  if missing_plugins.any?
    puts "❌ ERROR: Missing required plugins: #{missing_plugins.join(', ')}"
    return false
  end
  
  puts "✅ All plugins are GitHub Pages compatible!"
  puts "✅ Configured plugins: #{plugins.join(', ')}"
  puts "✅ All required plugins are present"
  puts "✅ No duplicate plugins found"
  puts "\n✅ Property 14 validated: GitHub Pages plugin compatibility"
  
  true
end

exit(validate_config ? 0 : 1)
