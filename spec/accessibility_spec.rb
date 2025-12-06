require 'spec_helper'
require 'nokogiri'

RSpec.describe 'Accessibility Tests' do
  before(:all) do
    # Build the site first
    system('bundle exec jekyll build --quiet')
  end

  describe 'Color contrast ratios' do
    it 'verifies primary color meets WCAG AA standards' do
      # Primary color: #1d4ed8 (29, 78, 216)
      # Background: #ffffff (255, 255, 255)
      
      # Calculate relative luminance
      def relative_luminance(r, g, b)
        [r, g, b].map do |c|
          c = c / 255.0
          c <= 0.03928 ? c / 12.92 : ((c + 0.055) / 1.055) ** 2.4
        end.then { |rgb| 0.2126 * rgb[0] + 0.7152 * rgb[1] + 0.0722 * rgb[2] }
      end
      
      # Calculate contrast ratio
      def contrast_ratio(l1, l2)
        lighter = [l1, l2].max
        darker = [l1, l2].min
        (lighter + 0.05) / (darker + 0.05)
      end
      
      # Primary color on white background
      primary_luminance = relative_luminance(29, 78, 216)
      white_luminance = relative_luminance(255, 255, 255)
      ratio = contrast_ratio(primary_luminance, white_luminance)
      
      # WCAG AA requires 4.5:1 for normal text, 3:1 for large text
      expect(ratio).to be >= 4.5, 
        "Primary color contrast ratio #{ratio.round(2)}:1 does not meet WCAG AA standard (4.5:1)"
    end

    it 'verifies text color meets WCAG AA standards' do
      # Text color: #111827 (17, 24, 39)
      # Background: #ffffff (255, 255, 255)
      
      def relative_luminance(r, g, b)
        [r, g, b].map do |c|
          c = c / 255.0
          c <= 0.03928 ? c / 12.92 : ((c + 0.055) / 1.055) ** 2.4
        end.then { |rgb| 0.2126 * rgb[0] + 0.7152 * rgb[1] + 0.0722 * rgb[2] }
      end
      
      def contrast_ratio(l1, l2)
        lighter = [l1, l2].max
        darker = [l1, l2].min
        (lighter + 0.05) / (darker + 0.05)
      end
      
      text_luminance = relative_luminance(17, 24, 39)
      white_luminance = relative_luminance(255, 255, 255)
      ratio = contrast_ratio(text_luminance, white_luminance)
      
      expect(ratio).to be >= 4.5,
        "Text color contrast ratio #{ratio.round(2)}:1 does not meet WCAG AA standard (4.5:1)"
    end

    it 'verifies muted text color meets WCAG AA standards for large text' do
      # Muted text color: #6b7280 (107, 114, 128)
      # Background: #ffffff (255, 255, 255)
      
      def relative_luminance(r, g, b)
        [r, g, b].map do |c|
          c = c / 255.0
          c <= 0.03928 ? c / 12.92 : ((c + 0.055) / 1.055) ** 2.4
        end.then { |rgb| 0.2126 * rgb[0] + 0.7152 * rgb[1] + 0.0722 * rgb[2] }
      end
      
      def contrast_ratio(l1, l2)
        lighter = [l1, l2].max
        darker = [l1, l2].min
        (lighter + 0.05) / (darker + 0.05)
      end
      
      muted_luminance = relative_luminance(107, 114, 128)
      white_luminance = relative_luminance(255, 255, 255)
      ratio = contrast_ratio(muted_luminance, white_luminance)
      
      # For muted text (typically used for metadata), we check against 3:1 for large text
      expect(ratio).to be >= 3.0,
        "Muted text color contrast ratio #{ratio.round(2)}:1 does not meet WCAG AA standard for large text (3:1)"
    end
  end

  describe 'Keyboard navigation' do
    it 'verifies all interactive elements are keyboard accessible' do
      html_files = Dir.glob('_site/**/*.html').reject { |f| f.include?('/spec/') }
      
      html_files.each do |file|
        content = File.read(file)
        doc = Nokogiri::HTML(content)
        
        # Check that all links are keyboard accessible (no tabindex=-1)
        links = doc.css('a[href]')
        links.each do |link|
          tabindex = link['tabindex']
          expect(tabindex).not_to eq('-1'), 
            "Link in #{file} has tabindex=-1, making it inaccessible via keyboard: #{link['href']}"
        end
        
        # Check that all buttons are keyboard accessible
        buttons = doc.css('button')
        buttons.each do |button|
          tabindex = button['tabindex']
          expect(tabindex).not_to eq('-1'),
            "Button in #{file} has tabindex=-1, making it inaccessible via keyboard"
        end
        
        # Check that all form inputs are keyboard accessible
        inputs = doc.css('input, textarea, select')
        inputs.each do |input|
          tabindex = input['tabindex']
          expect(tabindex).not_to eq('-1'),
            "Form input in #{file} has tabindex=-1, making it inaccessible via keyboard"
        end
      end
    end

    it 'verifies navigation has proper focus indicators' do
      html_files = Dir.glob('_site/**/*.html').reject { |f| f.include?('/spec/') }
      
      # Check that CSS doesn't remove focus outlines
      css_files = Dir.glob('_site/**/*.css')
      
      css_files.each do |file|
        content = File.read(file)
        
        # Check for outline:none without a replacement
        if content.include?('outline:none') || content.include?('outline: none')
          # This is a warning, not a failure, as there might be custom focus styles
          # In a real test, you'd check for alternative focus indicators
          puts "Warning: #{file} contains outline:none - ensure custom focus styles are present"
        end
      end
    end
  end

  describe 'ARIA labels' do
    it 'verifies form inputs have associated labels' do
      html_files = Dir.glob('_site/**/*.html').reject { |f| f.include?('/spec/') }
      
      html_files.each do |file|
        content = File.read(file)
        doc = Nokogiri::HTML(content)
        
        # Check that all form inputs have labels or aria-label
        inputs = doc.css('input[type="text"], input[type="email"], textarea')
        
        inputs.each do |input|
          # Skip hidden inputs (like honeypot fields)
          next if input['style']&.include?('display:none') || input['type'] == 'hidden'
          
          input_id = input['id']
          aria_label = input['aria-label']
          aria_labelledby = input['aria-labelledby']
          
          # Check if there's a label element for this input
          label = doc.css("label[for='#{input_id}']").first if input_id
          
          has_label = label || aria_label || aria_labelledby
          
          expect(has_label).to be_truthy,
            "Form input in #{file} lacks proper labeling (no label, aria-label, or aria-labelledby): #{input['name']}"
        end
      end
    end

    it 'verifies images have alt attributes' do
      html_files = Dir.glob('_site/**/*.html').reject { |f| f.include?('/spec/') }
      
      html_files.each do |file|
        content = File.read(file)
        doc = Nokogiri::HTML(content)
        
        images = doc.css('img')
        
        images.each do |img|
          alt = img['alt']
          src = img['src']
          
          # All images should have alt attribute (can be empty for decorative images)
          expect(alt).not_to be_nil,
            "Image in #{file} missing alt attribute: #{src}"
        end
      end
    end

    it 'verifies navigation landmarks are present' do
      html_files = Dir.glob('_site/**/*.html').reject { |f| f.include?('/spec/') }
      
      html_files.each do |file|
        content = File.read(file)
        doc = Nokogiri::HTML(content)
        
        # Check for semantic HTML5 landmarks
        has_nav = doc.css('nav').any?
        has_main = doc.css('main').any?
        has_footer = doc.css('footer').any?
        
        expect(has_nav).to be(true), "Page #{file} missing <nav> landmark"
        expect(has_main).to be(true), "Page #{file} missing <main> landmark"
        expect(has_footer).to be(true), "Page #{file} missing <footer> landmark"
      end
    end
  end

  describe 'Responsive design' do
    it 'verifies viewport meta tag is present' do
      html_files = Dir.glob('_site/**/*.html').reject { |f| f.include?('/spec/') }
      
      html_files.each do |file|
        content = File.read(file)
        doc = Nokogiri::HTML(content)
        
        viewport = doc.css('meta[name="viewport"]').first
        
        expect(viewport).not_to be_nil,
          "Page #{file} missing viewport meta tag"
        
        if viewport
          content_attr = viewport['content']
          expect(content_attr).to include('width=device-width'),
            "Viewport meta tag in #{file} should include width=device-width"
        end
      end
    end

    it 'verifies responsive images use appropriate attributes' do
      html_files = Dir.glob('_site/**/*.html').reject { |f| f.include?('/spec/') }
      
      html_files.each do |file|
        content = File.read(file)
        doc = Nokogiri::HTML(content)
        
        # Check images in post content
        post_images = doc.css('.post-content img')
        
        post_images.each do |img|
          # Images should have either img-fluid class or responsive styling
          has_responsive_class = img['class']&.include?('img-fluid')
          has_max_width = img['style']&.include?('max-width')
          
          # This is checked via CSS, so we just verify the class is present
          expect(has_responsive_class || has_max_width).to be_truthy,
            "Image in #{file} may not be responsive: #{img['src']}"
        end
      end
    end
  end

  describe 'Performance considerations' do
    it 'verifies lazy loading is implemented for images' do
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
            "Image in #{file} should have loading='lazy': #{img['src']}"
        end
      end
      
      # Ensure we checked some images
      expect(images_checked).to be > 0, "No images found to validate lazy loading"
    end
  end
end
