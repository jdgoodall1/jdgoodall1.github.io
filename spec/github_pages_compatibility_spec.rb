require 'spec_helper'

# Feature: jekyll-site-modernization, Property 14: GitHub Pages plugin compatibility
# Validates: Requirements 6.1
RSpec.describe "GitHub Pages Plugin Compatibility" do
  # GitHub Pages supported plugins whitelist as of Jekyll 3.9.x
  # Source: https://pages.github.com/versions/
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

  let(:config_file) { '_config.yml' }
  let(:config) { YAML.load_file(config_file) }

  describe "plugin whitelist validation" do
    it "ensures all configured plugins are in GitHub Pages whitelist" do
      plugins = config['plugins'] || []
      
      plugins.each do |plugin|
        expect(GITHUB_PAGES_PLUGINS).to include(plugin),
          "Plugin '#{plugin}' is not supported by GitHub Pages. " \
          "Supported plugins: #{GITHUB_PAGES_PLUGINS.join(', ')}"
      end
    end
  end

  describe "property-based plugin validation" do
    # Feature: jekyll-site-modernization, Property 14: GitHub Pages plugin compatibility
    # For any plugin listed in _config.yml, it should be in the GitHub Pages whitelist
    it "validates that any plugin configuration only uses whitelisted plugins" do
      cfg = config
      property_of {
        # Generate a random subset of plugins from our config
        plugins = cfg['plugins'] || []
        plugins.sample(rand(0..plugins.length))
      }.check(100) do |plugin_subset|
        # Every plugin in any subset should be whitelisted
        plugin_subset.each do |plugin|
          expect(GITHUB_PAGES_PLUGINS).to include(plugin),
            "Plugin '#{plugin}' is not in GitHub Pages whitelist"
        end
      end
    end

    it "validates plugin list structure and format" do
      cfg = config
      property_of {
        # Generate random plugin list configurations
        cfg['plugins'] || []
      }.check(100) do |plugins|
        # Plugins should be an array
        expect(plugins).to be_a(Array), "Plugins should be an array"
        
        # Each plugin should be a string
        plugins.each do |plugin|
          expect(plugin).to be_a(String), "Each plugin should be a string"
          expect(plugin).to match(/^jekyll-[\w-]+$|^jemoji$/), 
            "Plugin '#{plugin}' should follow naming convention"
        end
      end
    end
  end

  describe "configuration validation" do
    it "ensures _config.yml exists and is valid YAML" do
      expect(File.exist?(config_file)).to be true
      expect { YAML.load_file(config_file) }.not_to raise_error
    end

    it "ensures plugins key exists in configuration" do
      expect(config).to have_key('plugins')
      expect(config['plugins']).to be_a(Array)
    end

    it "ensures no duplicate plugins in configuration" do
      plugins = config['plugins'] || []
      expect(plugins.uniq.length).to eq(plugins.length),
        "Configuration contains duplicate plugins: #{plugins.group_by(&:itself).select { |k, v| v.size > 1 }.keys}"
    end
  end

  describe "specific plugin requirements" do
    it "includes required plugins for the site" do
      required_plugins = ['jekyll-feed', 'jekyll-seo-tag', 'jekyll-sitemap', 'jekyll-paginate']
      plugins = config['plugins'] || []
      
      required_plugins.each do |required_plugin|
        expect(plugins).to include(required_plugin),
          "Required plugin '#{required_plugin}' is missing from configuration"
      end
    end
  end
end
