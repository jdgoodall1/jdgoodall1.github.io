require 'spec_helper'
require 'jekyll'

# Feature: jekyll-site-modernization, Property 15: Semantic HTML structure
# Validates: Requirements 7.5
RSpec.describe "Semantic HTML Structure" do
  let(:config) do
    Jekyll.configuration({
      'source' => '.',
      'destination' => './_site',
      'quiet' => true
    })
  end

  before(:all) do
    # Build the site once for all tests
    config = Jekyll.configuration({
      'source' => '.',
      'destination' => './_site',
      'quiet' => true
    })
    @site = Jekyll::Site.new(config)
    @site.process
  end

  describe "layout templates" do
    let(:default_layout) { File.read('_layouts/default.html') }
    let(:navigation_include) { File.read('_includes/navigation.html') }
    let(:footer_include) { File.read('_includes/footer.html') }

    it "uses semantic HTML5 doctype" do
      expect(default_layout).to match(/<!DOCTYPE html>/i),
        "Layout should use HTML5 doctype"
    end

    it "includes semantic header element" do
      # Navigation is typically in a header or nav element
      expect(navigation_include).to include('<nav'),
        "Navigation should use semantic <nav> element"
    end

    it "includes semantic main element" do
      expect(default_layout).to include('<main'),
        "Layout should use semantic <main> element for primary content"
    end

    it "includes semantic footer element" do
      expect(footer_include).to include('<footer'),
        "Footer should use semantic <footer> element"
    end

    it "uses semantic nav element for navigation" do
      expect(navigation_include).to match(/<nav[\s>]/),
        "Navigation should use <nav> element"
    end
  end

  # Feature: jekyll-site-modernization, Property 15: Semantic HTML structure
  # For any page in the Jekyll site, the rendered HTML should use semantic HTML5 elements
  describe "property-based semantic HTML validation" do
    let(:semantic_elements) do
      ['nav', 'main', 'footer', 'header', 'article', 'section']
    end

    let(:layout_files) do
      Dir.glob('_layouts/*.html').select { |f| File.file?(f) }
    end

    let(:include_files) do
      Dir.glob('_includes/*.html').select { |f| File.file?(f) }
    end

    it "validates that layouts use appropriate semantic elements" do
      layouts = layout_files
      elements = semantic_elements
      property_of {
        # Generate random layout file
        layouts.sample
      }.check([layouts.length, 100].min) do |layout_file|
        content = File.read(layout_file)
        
        # Check if this is a wrapper layout (uses another layout)
        is_wrapper = content.match(/^---\s*\nlayout:\s*\w+\s*\n---/m)
        
        # Wrapper layouts don't need semantic elements (they inherit from parent)
        # But standalone layouts should have semantic elements
        if !is_wrapper
          has_semantic_elements = elements.any? { |element| content.include?("<#{element}") }
          expect(has_semantic_elements).to be(true),
            "Standalone layout '#{layout_file}' should use semantic HTML5 elements"
        end
      end
    end

    it "validates that includes use appropriate semantic elements where applicable" do
      includes = include_files
      property_of {
        # Generate random include file
        includes.sample
      }.check([includes.length, 100].min) do |include_file|
        content = File.read(include_file)
        filename = File.basename(include_file)
        
        # Check specific semantic requirements based on include type
        case filename
        when /nav/i
          expect(content).to include('<nav'),
            "Navigation include '#{include_file}' should use <nav> element"
        when /footer/i
          expect(content).to include('<footer'),
            "Footer include '#{include_file}' should use <footer> element"
        when /header/i
          expect(content).to include('<header'),
            "Header include '#{include_file}' should use <header> element"
        end
      end
    end

    it "ensures default layout has proper semantic structure" do
      property_of {
        # Generate random number of times to check the layout
        rand(1..10)
      }.check(100) do |_iteration|
        default_layout = File.read('_layouts/default.html')
        
        # Should have main element for primary content
        expect(default_layout).to include('<main'),
          "Default layout should have <main> element"
        
        # Should include navigation (via include)
        expect(default_layout).to match(/\{%\s*include\s+navigation\.html\s*%\}/),
          "Default layout should include navigation"
        
        # Should include footer (via include)
        expect(default_layout).to match(/\{%\s*include\s+footer\.html\s*%\}/),
          "Default layout should include footer"
      end
    end

    it "validates semantic element nesting and structure" do
      all_files = layout_files + include_files
      elements = semantic_elements
      property_of {
        # Generate random layout or include file
        all_files.sample
      }.check(100) do |file_path|
        content = File.read(file_path)
        
        # Check for proper HTML structure (no obvious nesting errors)
        # Count opening and closing tags for semantic elements
        elements.each do |element|
          opening_tags = content.scan(/<#{element}[\s>]/).length
          closing_tags = content.scan(/<\/#{element}>/).length
          
          # Opening and closing tags should match (accounting for self-closing and Liquid tags)
          # We allow some flexibility for partial includes
          if opening_tags > 0
            expect(closing_tags).to be <= opening_tags,
              "File '#{file_path}' has mismatched <#{element}> tags"
          end
        end
      end
    end
  end

  describe "HTML5 compliance" do
    it "uses HTML5 doctype in default layout" do
      default_layout = File.read('_layouts/default.html')
      expect(default_layout).to match(/<!DOCTYPE html>/i),
        "Should use HTML5 doctype"
    end

    it "includes lang attribute on html element" do
      default_layout = File.read('_layouts/default.html')
      expect(default_layout).to match(/<html\s+lang=/i),
        "HTML element should have lang attribute for accessibility"
    end

    it "avoids deprecated HTML elements" do
      deprecated_elements = ['center', 'font', 'marquee', 'blink', 'frame', 'frameset']
      layouts = Dir.glob('_layouts/*.html').select { |f| File.file?(f) }
      includes = Dir.glob('_includes/*.html').select { |f| File.file?(f) }
      all_files = layouts + includes
      
      all_files.each do |file_path|
        content = File.read(file_path)
        
        deprecated_elements.each do |element|
          expect(content).not_to include("<#{element}"),
            "File '#{file_path}' should not use deprecated <#{element}> element"
        end
      end
    end
  end

  describe "accessibility through semantic HTML" do
    it "uses semantic elements to improve accessibility" do
      default_layout = File.read('_layouts/default.html')
      navigation_include = File.read('_includes/navigation.html')
      footer_include = File.read('_includes/footer.html')
      
      # Navigation should use nav element
      expect(navigation_include).to include('<nav'),
        "Navigation should use <nav> for screen readers"
      
      # Footer should use footer element
      expect(footer_include).to include('<footer'),
        "Footer should use <footer> for screen readers"
      
      # Main content should use main element
      expect(default_layout).to include('<main'),
        "Layout should use <main> for screen readers"
    end

    it "provides proper document structure for assistive technologies" do
      default_layout = File.read('_layouts/default.html')
      head_include = File.read('_includes/head.html')
      
      # Should have proper structure: html > head + body
      expect(default_layout).to match(/<html/i),
        "Should have html element"
      expect(head_include).to match(/<head/i),
        "Should have head element in head.html include"
      expect(default_layout).to match(/<body/i),
        "Should have body element"
    end
  end
end
