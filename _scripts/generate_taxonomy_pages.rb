#!/usr/bin/env ruby
# Generate category and tag pages dynamically from posts

require 'yaml'

# Directories
POSTS_DIR = '_posts'
CATEGORIES_DIR = 'blog/categories'
TAGS_DIR = 'blog/tags'

# Ensure directories exist
Dir.mkdir(CATEGORIES_DIR) unless Dir.exist?(CATEGORIES_DIR)
Dir.mkdir(TAGS_DIR) unless Dir.exist?(TAGS_DIR)

# Collect all categories and tags from posts
categories = Set.new
tags = Set.new

Dir.glob("#{POSTS_DIR}/*.md").each do |post_file|
  content = File.read(post_file)
  
  # Extract front matter
  if content =~ /\A---\s*\n(.*?)\n---\s*\n/m
    front_matter = YAML.safe_load($1, permitted_classes: [Time, Date, Symbol], aliases: true)
    
    # Collect categories
    if front_matter['categories']
      front_matter['categories'].each { |cat| categories.add(cat) }
    end
    
    # Collect tags
    if front_matter['tags']
      front_matter['tags'].each { |tag| tags.add(tag) }
    end
  end
end

# Generate category pages
puts "Generating #{categories.size} category pages..."
categories.each do |category|
  slug = category.downcase.gsub(/\s+/, '-')
  filename = "#{CATEGORIES_DIR}/#{slug}.html"
  
  content = <<~CONTENT
    ---
    layout: category
    title: #{category}
    category: #{category}
    permalink: /blog/categories/#{slug}/
    ---
  CONTENT
  
  File.write(filename, content)
  puts "  Created: #{filename}"
end

# Generate tag pages
puts "Generating #{tags.size} tag pages..."
tags.each do |tag|
  slug = tag.downcase.gsub(/\s+/, '-')
  filename = "#{TAGS_DIR}/#{slug}.html"
  
  content = <<~CONTENT
    ---
    layout: tag
    title: #{tag}
    tag: #{tag}
    permalink: /blog/tags/#{slug}/
    ---
  CONTENT
  
  File.write(filename, content)
  puts "  Created: #{filename}"
end

puts "\nDone! Generated #{categories.size} categories and #{tags.size} tags."
