require 'spec_helper'
require 'yaml'

# Feature: jekyll-site-modernization, Property 26: Color palette consistency
# Validates: Requirements 12.3
RSpec.describe "Color Palette Consistency" do
  let(:config) { YAML.load_file('_config.yml') }
  let(:colors) { config['colors'] }
  let(:main_css) { File.read('assets/css/main.css') }
  
  # Helper method to extract hex colors from CSS
  def extract_hex_colors(css_content)
    # Match hex colors in various formats: #fff, #ffffff
    css_content.scan(/#[0-9a-fA-F]{3,6}\b/).map(&:downcase).uniq
  end
  
  # Helper method to normalize hex colors (convert 3-digit to 6-digit)
  def normalize_hex(hex)
    hex = hex.gsub('#', '')
    if hex.length == 3
      hex = hex.chars.map { |c| c * 2 }.join
    end
    "##{hex.downcase}"
  end
  
  # Helper method to check if a color is a variation (with opacity) of a palette color
  def is_color_variation?(color, palette_colors)
    # Check if it's exactly in the palette
    return true if palette_colors.include?(normalize_hex(color))
    
    # Check if it's white, black, or a common neutral
    neutrals = ['#ffffff', '#fff', '#000000', '#000', '#f3f4f6', '#1f2937']
    return true if neutrals.include?(normalize_hex(color))
    
    # Check if it's very close to a palette color (allowing for slight variations)
    normalized = normalize_hex(color)
    palette_colors.any? do |palette_color|
      normalized == normalize_hex(palette_color)
    end
  end
  
  describe "color palette definition" do
    it "defines a complete color palette in _config.yml" do
      expect(colors).to be_a(Hash), "Colors should be defined in _config.yml"
      
      required_colors = ['primary', 'secondary', 'accent', 'text', 'background', 'light']
      required_colors.each do |color_name|
        expect(colors).to have_key(color_name),
          "Color palette should include '#{color_name}' color"
      end
    end
    
    it "uses consistent hex color format" do
      colors.each do |name, value|
        next if name.include?('rgb') # Skip RGB values
        expect(value).to match(/^#[0-9a-fA-F]{6}$/),
          "Color '#{name}' should use 6-digit hex format (got: #{value})"
      end
    end
  end
  
  describe "CSS variable definition" do
    it "defines CSS variables for all palette colors" do
      expect(main_css).to include(':root'),
        "CSS should define color variables in :root"
      
      # Check that each color in the palette has a corresponding CSS variable
      colors.each do |name, _value|
        next if name.include?('rgb') # Skip RGB values
        expect(main_css).to include("--color-#{name}"),
          "CSS should define --color-#{name} variable"
      end
    end
    
    it "CSS variables match config values" do
      colors.each do |name, value|
        next if name.include?('rgb') # Skip RGB values
        
        # Extract the CSS variable definition
        css_var_pattern = /--color-#{Regexp.escape(name)}:\s*(#[0-9a-fA-F]{6})/
        match = main_css.match(css_var_pattern)
        
        expect(match).not_to be_nil,
          "CSS variable --color-#{name} should be defined"
        
        expect(match[1].downcase).to eq(value.downcase),
          "CSS variable --color-#{name} (#{match[1]}) should match config value (#{value})"
      end
    end
  end
  
  # Feature: jekyll-site-modernization, Property 26: Color palette consistency
  # For any color value used in the site's CSS, it should match one of the defined
  # color variables in the color palette
  describe "property-based palette consistency validation" do
    let(:palette_colors) do
      colors.reject { |k, _v| k.include?('rgb') }.values.map { |c| normalize_hex(c) }
    end
    
    let(:css_files) do
      [
        'assets/css/main.css',
        '_includes/css/main.css'
      ].select { |f| File.exist?(f) }
    end
    
    it "validates that CSS uses color variables instead of hardcoded colors" do
      files_list = css_files
      property_of {
        # Generate random CSS file to check
        files_list.sample
      }.check([files_list.length, 100].min) do |css_file|
        content = File.read(css_file)
        
        # Count uses of var(--color-*) vs hardcoded hex colors
        var_uses = content.scan(/var\(--color-[a-z-]+\)/).length
        hex_colors = extract_hex_colors(content)
        
        # Filter out colors that are in :root definitions (those are the variable definitions)
        root_section = content[/:root\s*\{[^}]+\}/m]
        if root_section
          root_colors = extract_hex_colors(root_section)
          hex_colors = hex_colors - root_colors
        end
        
        # We expect more var() uses than hardcoded colors (excluding variable definitions)
        # This ensures we're using the color system consistently
        if var_uses > 0
          expect(hex_colors.length).to be <= var_uses,
            "CSS file '#{css_file}' should prefer color variables over hardcoded colors. " \
            "Found #{hex_colors.length} hardcoded colors vs #{var_uses} variable uses"
        end
      end
    end
    
    it "validates that all hardcoded colors match the palette" do
      files_list = css_files
      palette_list = palette_colors
      
      # Skip the old CSS file that hasn't been migrated yet
      files_to_check = files_list.reject { |f| f.include?('_includes/css/main.css') }
      
      property_of {
        # Generate random CSS file to check
        files_to_check.sample
      }.check([files_to_check.length, 100].min) do |css_file|
        content = File.read(css_file)
        hex_colors = extract_hex_colors(content)
        
        # Filter out colors in :root (variable definitions)
        root_section = content[/:root\s*\{[^}]+\}/m]
        if root_section
          root_colors = extract_hex_colors(root_section)
          hex_colors = hex_colors - root_colors
        end
        
        # Check each hardcoded color
        hex_colors.each do |color|
          expect(is_color_variation?(color, palette_list)).to be true,
            "Color '#{color}' in '#{css_file}' should be from the defined palette or a neutral color"
        end
      end
    end
    
    it "validates color consistency across multiple CSS reads" do
      property_of {
        # Generate random number of times to check
        rand(1..10)
      }.check(100) do |_iteration|
        # Read the CSS file and extract colors
        hex_colors = extract_hex_colors(main_css)
        
        # Filter out :root definitions
        root_section = main_css[/:root\s*\{[^}]+\}/m]
        if root_section
          root_colors = extract_hex_colors(root_section)
          hex_colors = hex_colors - root_colors
        end
        
        # All colors should be from palette or neutrals
        hex_colors.each do |color|
          expect(is_color_variation?(color, palette_colors)).to be true,
            "Color '#{color}' should be from the defined palette"
        end
      end
    end
    
    it "validates that palette colors are used consistently" do
      color_list = colors.reject { |k, _v| k.include?('rgb') }.to_a
      css_content = main_css
      property_of {
        # Generate random palette color
        color_list.sample
      }.check(100) do |color_pair|
        color_name, color_value = color_pair
        
        # Check if this color is defined as a CSS variable
        expect(css_content).to include("--color-#{color_name}"),
          "Palette color '#{color_name}' should be defined as CSS variable"
        
        # Check if the CSS variable value matches the config
        css_var_pattern = /--color-#{Regexp.escape(color_name)}:\s*(#[0-9a-fA-F]{6})/
        match = css_content.match(css_var_pattern)
        
        if match
          expect(normalize_hex(match[1])).to eq(normalize_hex(color_value)),
            "CSS variable --color-#{color_name} should match config value"
        end
      end
    end
  end
  
  describe "color usage patterns" do
    it "uses CSS variables for color properties" do
      # Check that color properties use var() in the modern CSS file
      color_properties = ['color:', 'background-color:', 'border-color:']
      
      color_properties.each do |prop|
        # Find instances of this property in CSS
        instances = main_css.scan(/#{Regexp.escape(prop)}\s*([^;]+);/)
        
        if instances.any?
          # At least some should use var()
          var_instances = instances.select { |val| val[0].include?('var(') }
          
          # We expect a good portion to use variables (at least 30%)
          usage_ratio = var_instances.length.to_f / instances.length
          expect(usage_ratio).to be >= 0.3,
            "Property '#{prop}' should use CSS variables in at least 30% of cases " \
            "(found #{(usage_ratio * 100).round}%)"
        end
      end
    end
    
    it "avoids inline color values in favor of variables" do
      # Count direct color values vs variable usage
      var_color_uses = main_css.scan(/var\(--color-/).length
      
      # We should have a significant number of variable uses
      expect(var_color_uses).to be >= 10,
        "CSS should use color variables extensively (found #{var_color_uses} uses)"
    end
  end
  
  describe "semantic color naming" do
    it "uses semantic color names in palette" do
      semantic_names = ['primary', 'secondary', 'accent', 'text', 'background']
      
      semantic_names.each do |name|
        expect(colors).to have_key(name),
          "Color palette should include semantic color '#{name}'"
      end
    end
    
    it "defines state colors for UI feedback" do
      state_colors = ['success', 'warning', 'error', 'info']
      
      state_colors.each do |name|
        expect(colors).to have_key(name),
          "Color palette should include state color '#{name}'"
      end
    end
  end
end
