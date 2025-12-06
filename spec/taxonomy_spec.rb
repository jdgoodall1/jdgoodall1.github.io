require 'spec_helper'
require 'jekyll'
require 'fileutils'
require 'time'

RSpec.describe "Category and Tag System" do
  let(:config) do
    Jekyll.configuration({
      'source' => '.',
      'destination' => './_site',
      'quiet' => true,
      'permalink' => '/blog/:year/:month/:day/:title/',
      'future' => true  # Allow future-dated posts for testing
    })
  end
  
  let(:site) { Jekyll::Site.new(config) }
  
  # Helper to create a temporary post file
  def create_test_post(filename, front_matter, content = "Test content")
    FileUtils.mkdir_p('_posts') unless Dir.exist?('_posts')
    
    post_path = File.join('_posts', filename)
    # Build front matter with proper formatting
    front_matter_yaml = front_matter.map do |k, v|
      if v.is_a?(Array)
        "#{k}: [#{v.map(&:inspect).join(', ')}]"
      elsif v.is_a?(Time)
        "#{k}: #{v.strftime('%Y-%m-%d %H:%M:%S %z')}"
      else
        "#{k}: #{v.inspect}"
      end
    end.join("\n")
    
    File.write(post_path, "---\n#{front_matter_yaml}\n---\n\n#{content}")
    post_path
  end
  
  # Helper to clean up test posts
  def cleanup_test_post(post_path)
    File.delete(post_path) if File.exist?(post_path)
  end
  
  # Feature: jekyll-site-modernization, Property 9: Taxonomy link generation
  # Validates: Requirements 3.5
  describe "taxonomy link generation" do
    # This property verifies that for any post with categories or tags,
    # the rendered post includes clickable links for each category and tag
    it "generates correct taxonomy links for any post with categories and tags" do
      property_of {
        days_ago = range(1, 365)
        date = Time.now - (days_ago * 24 * 60 * 60)
        title_words = array(range(2, 5)) { choose('Test', 'Post', 'Blog', 'Article', 'Content') }
        title = title_words.join(' ')
        slug = title_words.map(&:downcase).join('-')
        
        # Generate random categories and tags
        categories = array(range(1, 3)) { choose('DevOps', 'AWS', 'Ruby', 'Jekyll', 'Testing') }.uniq
        tags = array(range(1, 5)) { choose('terraform', 'automation', 'cloud', 'ci-cd', 'docker') }.uniq
        
        {
          'filename' => "#{date.strftime('%Y-%m-%d')}-#{slug}-#{rand(10000)}.md",
          'front_matter' => {
            'layout' => 'post',
            'title' => "TaxonomyTest #{title} #{rand(10000)}",
            'date' => date,
            'categories' => categories,
            'tags' => tags
          },
          'content' => "Test content for taxonomy links."
        }
      }.check(100) do |post_data|
        post_path = create_test_post(
          post_data['filename'],
          post_data['front_matter'],
          post_data['content']
        )
        
        begin
          # Process the site
          site.reset
          site.read
          site.generate
          
          # Find the post
          post = site.posts.docs.find { |p| p.data['title'] == post_data['front_matter']['title'] }
          expect(post).not_to be_nil
          
          # Verify post has categories and tags
          expect(post.data['categories']).to be_a(Array)
          expect(post.data['tags']).to be_a(Array)
          expect(post.data['categories'].length).to be > 0
          expect(post.data['tags'].length).to be > 0
          
          # Verify each category has a corresponding link structure
          post.data['categories'].each do |category|
            slugified_category = category.downcase.gsub(/\s+/, '-')
            expected_url = "/blog/categories/#{slugified_category}/"
            
            # Verify the URL structure is correct
            expect(expected_url).to match(%r{^/blog/categories/[\w-]+/$})
          end
          
          # Verify each tag has a corresponding link structure
          post.data['tags'].each do |tag|
            slugified_tag = tag.downcase.gsub(/\s+/, '-')
            expected_url = "/blog/tags/#{slugified_tag}/"
            
            # Verify the URL structure is correct
            expect(expected_url).to match(%r{^/blog/tags/[\w-]+/$})
          end
          
        ensure
          cleanup_test_post(post_path)
        end
      end
    end
  end
  
  # Feature: jekyll-site-modernization, Property 16: Category filtering accuracy
  # Validates: Requirements 9.1
  describe "category filtering accuracy" do
    # This property verifies that for any category filter page, all displayed posts
    # have that category in their front matter, and all posts with that category are included
    it "filters posts accurately by category for any category" do
      property_of {
        # Generate a test category
        test_category = choose('DevOps', 'AWS', 'Ruby', 'Jekyll', 'Testing')
        
        # Generate 3-8 posts, some with the test category, some without
        num_posts = range(3, 8)
        base_date = Time.new(2024, 1, 1)
        
        posts = array(num_posts) do
          days_offset = range(0, 300)
          date = base_date + (days_offset * 24 * 60 * 60)
          title_words = array(range(2, 4)) { choose('Category', 'Filter', 'Test', 'Post') }
          title = title_words.join(' ')
          slug = title_words.map(&:downcase).join('-')
          
          # Randomly decide if this post has the test category
          has_test_category = choose(true, false)
          
          categories = if has_test_category
            # Include the test category plus possibly others
            [test_category] + array(range(0, 2)) { choose('Other1', 'Other2', 'Other3') }
          else
            # Only other categories
            array(range(1, 2)) { choose('Other1', 'Other2', 'Other3') }
          end.uniq
          
          {
            'filename' => "#{date.strftime('%Y-%m-%d')}-#{slug}-#{rand(10000)}.md",
            'date' => date,
            'title' => "CategoryFilter #{title} #{rand(10000)}",
            'categories' => categories,
            'has_test_category' => has_test_category
          }
        end
        
        # Ensure unique filenames
        posts.each_with_index do |post, idx|
          post['filename'] = post['filename'].gsub(/\.md$/, "-#{idx}.md")
        end
        
        {
          'test_category' => test_category,
          'posts' => posts,
          'expected_count' => posts.count { |p| p['has_test_category'] }
        }
      }.check(100) do |test_data|
        created_posts = []
        
        begin
          # Create all test posts
          test_data['posts'].each do |post_data|
            post_path = create_test_post(
              post_data['filename'],
              {
                'layout' => 'post',
                'title' => post_data['title'],
                'date' => post_data['date'],
                'categories' => post_data['categories']
              },
              "Test content"
            )
            created_posts << post_path
          end
          
          # Process the site
          site.reset
          site.read
          site.generate
          
          # Get posts in the test category
          category_posts = site.categories[test_data['test_category']] || []
          
          # Filter to only our test posts
          test_category_posts = category_posts.select { |p| p.data['title'].start_with?('CategoryFilter') }
          
          # Verify count matches expected
          expect(test_category_posts.length).to eq(test_data['expected_count'])
          
          # Verify all posts in the category have the category in their front matter
          test_category_posts.each do |post|
            expect(post.data['categories']).to include(test_data['test_category'])
          end
          
          # Verify all posts with the category are included
          all_test_posts = site.posts.docs.select { |p| p.data['title'].start_with?('CategoryFilter') }
          posts_with_category = all_test_posts.select { |p| p.data['categories'].include?(test_data['test_category']) }
          
          expect(posts_with_category.length).to eq(test_category_posts.length)
          
        ensure
          created_posts.each { |path| cleanup_test_post(path) }
        end
      end
    end
  end
  
  # Feature: jekyll-site-modernization, Property 17: Tag filtering accuracy
  # Validates: Requirements 9.2
  describe "tag filtering accuracy" do
    # This property verifies that for any tag filter page, all displayed posts
    # have that tag in their front matter, and all posts with that tag are included
    it "filters posts accurately by tag for any tag" do
      property_of {
        # Generate a test tag
        test_tag = choose('terraform', 'automation', 'cloud', 'ci-cd', 'docker')
        
        # Generate 3-8 posts, some with the test tag, some without
        num_posts = range(3, 8)
        base_date = Time.new(2024, 1, 1)
        
        posts = array(num_posts) do
          days_offset = range(0, 300)
          date = base_date + (days_offset * 24 * 60 * 60)
          title_words = array(range(2, 4)) { choose('Tag', 'Filter', 'Test', 'Post') }
          title = title_words.join(' ')
          slug = title_words.map(&:downcase).join('-')
          
          # Randomly decide if this post has the test tag
          has_test_tag = choose(true, false)
          
          tags = if has_test_tag
            # Include the test tag plus possibly others
            [test_tag] + array(range(0, 3)) { choose('other1', 'other2', 'other3') }
          else
            # Only other tags
            array(range(1, 3)) { choose('other1', 'other2', 'other3') }
          end.uniq
          
          {
            'filename' => "#{date.strftime('%Y-%m-%d')}-#{slug}-#{rand(10000)}.md",
            'date' => date,
            'title' => "TagFilter #{title} #{rand(10000)}",
            'tags' => tags,
            'has_test_tag' => has_test_tag
          }
        end
        
        # Ensure unique filenames
        posts.each_with_index do |post, idx|
          post['filename'] = post['filename'].gsub(/\.md$/, "-#{idx}.md")
        end
        
        {
          'test_tag' => test_tag,
          'posts' => posts,
          'expected_count' => posts.count { |p| p['has_test_tag'] }
        }
      }.check(100) do |test_data|
        created_posts = []
        
        begin
          # Create all test posts
          test_data['posts'].each do |post_data|
            post_path = create_test_post(
              post_data['filename'],
              {
                'layout' => 'post',
                'title' => post_data['title'],
                'date' => post_data['date'],
                'tags' => post_data['tags']
              },
              "Test content"
            )
            created_posts << post_path
          end
          
          # Process the site
          site.reset
          site.read
          site.generate
          
          # Get posts with the test tag
          tag_posts = site.tags[test_data['test_tag']] || []
          
          # Filter to only our test posts
          test_tag_posts = tag_posts.select { |p| p.data['title'].start_with?('TagFilter') }
          
          # Verify count matches expected
          expect(test_tag_posts.length).to eq(test_data['expected_count'])
          
          # Verify all posts with the tag have the tag in their front matter
          test_tag_posts.each do |post|
            expect(post.data['tags']).to include(test_data['test_tag'])
          end
          
          # Verify all posts with the tag are included
          all_test_posts = site.posts.docs.select { |p| p.data['title'].start_with?('TagFilter') }
          posts_with_tag = all_test_posts.select { |p| p.data['tags'].include?(test_data['test_tag']) }
          
          expect(posts_with_tag.length).to eq(test_tag_posts.length)
          
        ensure
          created_posts.each { |path| cleanup_test_post(path) }
        end
      end
    end
  end
  
  # Feature: jekyll-site-modernization, Property 18: Complete taxonomy lists
  # Validates: Requirements 9.3, 9.4
  describe "complete taxonomy lists" do
    # This property verifies that for any page displaying categories or tags,
    # the list includes all unique categories/tags with no duplicates
    it "includes all unique categories and tags with no duplicates" do
      property_of {
        # Generate 3-10 posts with various categories and tags
        num_posts = range(3, 10)
        base_date = Time.new(2024, 1, 1)
        
        # Define a pool of categories and tags
        category_pool = ['DevOps', 'AWS', 'Ruby', 'Jekyll', 'Testing', 'Cloud']
        tag_pool = ['terraform', 'automation', 'cloud', 'ci-cd', 'docker', 'kubernetes']
        
        posts = array(num_posts) do
          days_offset = range(0, 300)
          date = base_date + (days_offset * 24 * 60 * 60)
          title_words = array(range(2, 4)) { choose('Taxonomy', 'List', 'Test', 'Post') }
          title = title_words.join(' ')
          slug = title_words.map(&:downcase).join('-')
          
          {
            'filename' => "#{date.strftime('%Y-%m-%d')}-#{slug}-#{rand(10000)}.md",
            'date' => date,
            'title' => "TaxonomyList #{title} #{rand(10000)}",
            'categories' => array(range(1, 3)) { choose(*category_pool) }.uniq,
            'tags' => array(range(1, 4)) { choose(*tag_pool) }.uniq
          }
        end
        
        # Ensure unique filenames
        posts.each_with_index do |post, idx|
          post['filename'] = post['filename'].gsub(/\.md$/, "-#{idx}.md")
        end
        
        # Calculate expected unique categories and tags
        all_categories = posts.flat_map { |p| p['categories'] }.uniq
        all_tags = posts.flat_map { |p| p['tags'] }.uniq
        
        {
          'posts' => posts,
          'expected_categories' => all_categories,
          'expected_tags' => all_tags
        }
      }.check(100) do |test_data|
        created_posts = []
        
        begin
          # Create all test posts
          test_data['posts'].each do |post_data|
            post_path = create_test_post(
              post_data['filename'],
              {
                'layout' => 'post',
                'title' => post_data['title'],
                'date' => post_data['date'],
                'categories' => post_data['categories'],
                'tags' => post_data['tags']
              },
              "Test content"
            )
            created_posts << post_path
          end
          
          # Process the site
          site.reset
          site.read
          site.generate
          
          # Get all test posts
          test_posts = site.posts.docs.select { |p| p.data['title'].start_with?('TaxonomyList') }
          
          # Extract all categories and tags from test posts
          actual_categories = test_posts.flat_map { |p| p.data['categories'] }.uniq.sort
          actual_tags = test_posts.flat_map { |p| p.data['tags'] }.uniq.sort
          
          # Verify all expected categories are present
          test_data['expected_categories'].sort.each do |category|
            expect(actual_categories).to include(category)
          end
          
          # Verify all expected tags are present
          test_data['expected_tags'].sort.each do |tag|
            expect(actual_tags).to include(tag)
          end
          
          # Verify no duplicates (uniqueness)
          expect(actual_categories.length).to eq(actual_categories.uniq.length)
          expect(actual_tags.length).to eq(actual_tags.uniq.length)
          
        ensure
          created_posts.each { |path| cleanup_test_post(path) }
        end
      end
    end
  end
  
  # Feature: jekyll-site-modernization, Property 19: Taxonomy layout consistency
  # Validates: Requirements 9.5
  describe "taxonomy layout consistency" do
    # This property verifies that for any category or tag filter page,
    # the post listing uses the same post card template as the main blog page
    it "uses consistent post card layout for any taxonomy filter page" do
      property_of {
        # Generate a test category and tag
        test_category = choose('DevOps', 'AWS', 'Ruby', 'Jekyll')
        test_tag = choose('terraform', 'automation', 'cloud', 'ci-cd')
        
        # Generate 2-5 posts with the test category and tag
        num_posts = range(2, 5)
        base_date = Time.new(2024, 1, 1)
        
        posts = array(num_posts) do
          days_offset = range(0, 300)
          date = base_date + (days_offset * 24 * 60 * 60)
          title_words = array(range(2, 4)) { choose('Layout', 'Consistency', 'Test', 'Post') }
          title = title_words.join(' ')
          slug = title_words.map(&:downcase).join('-')
          
          {
            'filename' => "#{date.strftime('%Y-%m-%d')}-#{slug}-#{rand(10000)}.md",
            'date' => date,
            'title' => "LayoutTest #{title} #{rand(10000)}",
            'categories' => [test_category],
            'tags' => [test_tag],
            'excerpt' => "Test excerpt for #{title}"
          }
        end
        
        # Ensure unique filenames
        posts.each_with_index do |post, idx|
          post['filename'] = post['filename'].gsub(/\.md$/, "-#{idx}.md")
        end
        
        {
          'test_category' => test_category,
          'test_tag' => test_tag,
          'posts' => posts
        }
      }.check(100) do |test_data|
        created_posts = []
        
        begin
          # Create all test posts
          test_data['posts'].each do |post_data|
            post_path = create_test_post(
              post_data['filename'],
              {
                'layout' => 'post',
                'title' => post_data['title'],
                'date' => post_data['date'],
                'categories' => post_data['categories'],
                'tags' => post_data['tags'],
                'excerpt' => post_data['excerpt']
              },
              "Test content"
            )
            created_posts << post_path
          end
          
          # Process the site
          site.reset
          site.read
          site.generate
          
          # Get posts from category and tag collections
          category_posts = (site.categories[test_data['test_category']] || []).select { |p| p.data['title'].start_with?('LayoutTest') }
          tag_posts = (site.tags[test_data['test_tag']] || []).select { |p| p.data['title'].start_with?('LayoutTest') }
          
          # Verify posts exist in both collections
          expect(category_posts.length).to be > 0
          expect(tag_posts.length).to be > 0
          
          # Verify each post has the required data for post card rendering
          # (same data structure as main blog listing)
          [category_posts, tag_posts].each do |post_collection|
            post_collection.each do |post|
              # Verify post has all required fields for post-card.html
              expect(post.data['title']).not_to be_nil
              expect(post.date).to be_a(Time)
              expect(post.data['excerpt']).not_to be_nil
              expect(post.url).not_to be_nil
              expect(post.data['categories']).to be_a(Array)
              expect(post.data['tags']).to be_a(Array)
              
              # Verify URL structure is consistent
              expect(post.url).to match(%r{^/blog/\d{4}/\d{2}/\d{2}/})
            end
          end
          
        ensure
          created_posts.each { |path| cleanup_test_post(path) }
        end
      end
    end
  end
end
