require 'spec_helper'
require 'nokogiri'

RSpec.describe 'HTML Validation' do
  before(:all) do
    # Build the site first
    system('bundle exec jekyll build --quiet')
  end

  describe 'Basic HTML structure validation' do
    it 'validates that all HTML files are well-formed' do
      html_files = Dir.glob('_site/**/*.html').reject { |f| f.include?('/spec/') }
      
      expect(html_files).not_to be_empty, "No HTML files found in _site directory"
      
      html_files.each do |file|
        content = File.read(file)
        doc = Nokogiri::HTML(content)
        
        # Check for basic HTML structure
        expect(doc.css('html')).not_to be_empty, "Missing <html> tag in #{file}"
        expect(doc.css('head')).not_to be_empty, "Missing <head> tag in #{file}"
        expect(doc.css('body')).not_to be_empty, "Missing <body> tag in #{file}"
      end
    end

    it 'checks for broken internal links' do
      html_files = Dir.glob('_site/**/*.html').reject { |f| f.include?('/spec/') }
      all_paths = html_files.map { |f| f.sub('_site', '') }
      
      broken_links = []
      
      html_files.each do |file|
        content = File.read(file)
        doc = Nokogiri::HTML(content)
        
        # Check internal links
        doc.css('a[href]').each do |link|
          href = link['href']
          
          # Skip external links, anchors, and special links
          next if href.nil? || href.start_with?('http', 'mailto:', 'tel:', '#')
          
          # Normalize the path
          normalized_href = href.split('#').first.sub(/\/$/, '')
          next if normalized_href.empty?
          
          # Check if the file exists
          target_path = File.join('_site', normalized_href)
          target_path_with_index = File.join(target_path, 'index.html')
          target_path_html = "#{target_path}.html"
          
          unless File.exist?(target_path) || File.exist?(target_path_with_index) || File.exist?(target_path_html)
            broken_links << { file: file, href: href }
          end
        end
      end
      
      if broken_links.any?
        message = "Found broken internal links:\n"
        broken_links.each do |link|
          message += "  #{link[:file]}: #{link[:href]}\n"
        end
        fail message
      end
    end
  end

  describe 'Heading hierarchy' do
    it 'verifies proper heading hierarchy on all pages' do
      html_files = Dir.glob('_site/**/*.html').reject { |f| f.include?('/spec/') }
      
      html_files.each do |file|
        content = File.read(file)
        doc = Nokogiri::HTML(content)
        
        # Get all headings
        headings = doc.css('h1, h2, h3, h4, h5, h6')
        
        next if headings.empty?
        
        # Check that we don't skip heading levels
        previous_level = 0
        headings.each do |heading|
          current_level = heading.name[1].to_i
          
          # Allow h1 at any point, but other headings shouldn't skip levels
          if current_level > 1
            level_diff = current_level - previous_level
            expect(level_diff).to be <= 1, 
              "Heading hierarchy violation in #{file}: #{heading.name} follows h#{previous_level}"
          end
          
          previous_level = current_level
        end
      end
    end

    it 'ensures each page has exactly one h1' do
      html_files = Dir.glob('_site/**/*.html').reject { |f| f.include?('/spec/') }
      
      html_files.each do |file|
        content = File.read(file)
        doc = Nokogiri::HTML(content)
        
        h1_count = doc.css('h1').length
        
        # Each page should have exactly one h1 (or none for some utility pages)
        expect(h1_count).to be <= 1, 
          "Multiple h1 tags found in #{file}"
      end
    end
  end

  describe 'Image validation' do
    it 'checks that all images have alt attributes' do
      html_files = Dir.glob('_site/**/*.html').reject { |f| f.include?('/spec/') }
      
      html_files.each do |file|
        content = File.read(file)
        doc = Nokogiri::HTML(content)
        
        images = doc.css('img')
        
        images.each do |img|
          src = img['src']
          alt = img['alt']
          
          # Skip decorative images or icons (can have empty alt)
          next if src&.include?('icon') || src&.include?('logo')
          
          expect(alt).not_to be_nil, 
            "Image missing alt attribute in #{file}: #{src}"
        end
      end
    end

    it 'verifies images have lazy loading attribute' do
      html_files = Dir.glob('_site/**/*.html').reject { |f| f.include?('/spec/') }
      
      images_checked = 0
      
      html_files.each do |file|
        content = File.read(file)
        doc = Nokogiri::HTML(content)
        
        # Check images in post content and post cards
        post_images = doc.css('.post-content img, .post-card img')
        
        post_images.each do |img|
          images_checked += 1
          loading = img['loading']
          
          expect(loading).to eq('lazy'), 
            "Image missing lazy loading in #{file}: #{img['src']}"
        end
      end
      
      # Ensure we actually checked some images
      expect(images_checked).to be > 0, "No images found to validate lazy loading"
    end
  end
end
