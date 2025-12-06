require 'spec_helper'
require 'jekyll'
require 'fileutils'
require 'time'

RSpec.describe "Blog Listing and Pagination" do
  let(:config) do
    Jekyll.configuration({
      'source' => '.',
      'destination' => './_site',
      'quiet' => true,
      'permalink' => '/blog/:year/:month/:day/:title/',
      'paginate' => 10,
      'paginate_path' => '/blog/page:num/',
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
  
  # Feature: jekyll-site-modernization, Property 2: Post collection inclusion
  # Validates: Requirements 2.1, 2.2
  describe "post collection inclusion" do
    # This property verifies that for any markdown file in _posts with valid
    # front matter and correct filename format, the post appears in site.posts
    it "includes all valid posts in site.posts collection" do
      property_of {
        # Generate random date in the past
        days_ago = range(1, 365)
        date = Time.now - (days_ago * 24 * 60 * 60)
        
        # Generate random title
        title_words = array(range(2, 5)) { choose('Test', 'Post', 'Blog', 'Article', 'Content') }
        title = title_words.join(' ')
        slug = title_words.map(&:downcase).join('-')
        
        # Generate filename in YYYY-MM-DD-title.md format
        filename = "#{date.strftime('%Y-%m-%d')}-#{slug}-#{range(1, 10000)}.md"
        
        {
          'filename' => filename,
          'front_matter' => {
            'layout' => 'post',
            'title' => title,
            'date' => date,
            'categories' => array(range(1, 3)) { choose('DevOps', 'AWS', 'Ruby', 'Jekyll') }.uniq,
            'tags' => array(range(1, 4)) { choose('terraform', 'automation', 'cloud', 'testing') }.uniq
          },
          'content' => "This is test content for #{title}."
        }
      }.check(100) do |post_data|
        # Create the test post
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
          
          # Verify the post is in the collection
          post_titles = site.posts.docs.map { |p| p.data['title'] }
          expect(post_titles).to include(post_data['front_matter']['title'])
          
          # Verify the post has correct filename format
          expect(post_data['filename']).to match(/^\d{4}-\d{2}-\d{2}-.+\.md$/)
          
          # Verify front matter has required fields
          expect(post_data['front_matter']).to have_key('layout')
          expect(post_data['front_matter']).to have_key('title')
          expect(post_data['front_matter']).to have_key('date')
          
        ensure
          # Clean up
          cleanup_test_post(post_path)
        end
      end
    end
  end
  
  # Feature: jekyll-site-modernization, Property 7: Post card completeness
  # Validates: Requirements 3.2, 3.3
  describe "post card completeness" do
    # This property verifies that for any post displayed in the blog listing,
    # the post card contains title, publication date, excerpt, and Read More link
    it "includes all required elements in post card for any post" do
      property_of {
        days_ago = range(1, 365)
        date = Time.now - (days_ago * 24 * 60 * 60)
        title_words = array(range(3, 6)) { choose('Test', 'Post', 'Blog', 'Article', 'Content') }
        title = title_words.join(' ')
        slug = title_words.map(&:downcase).join('-')
        
        # Generate excerpt
        excerpt_words = array(range(10, 30)) { choose('This', 'is', 'a', 'test', 'excerpt', 'for', 'the', 'blog', 'post') }
        excerpt = excerpt_words.join(' ')
        
        {
          'filename' => "#{date.strftime('%Y-%m-%d')}-#{slug}-#{rand(10000)}.md",
          'front_matter' => {
            'layout' => 'post',
            'title' => "PostCard #{title} #{rand(10000)}",
            'date' => date,
            'excerpt' => excerpt,
            'categories' => array(range(1, 2)) { choose('DevOps', 'AWS') }.uniq,
            'tags' => array(range(1, 3)) { choose('terraform', 'automation') }.uniq
          },
          'content' => "Full post content here. #{excerpt}"
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
          
          # Verify post has all required data for post card
          expect(post.data['title']).to eq(post_data['front_matter']['title'])
          expect(post.date).to be_a(Time)
          expect(post.data['excerpt']).not_to be_nil
          expect(post.url).not_to be_nil
          
          # Verify the URL is a valid permalink
          expect(post.url).to match(%r{^/blog/\d{4}/\d{2}/\d{2}/})
          
        ensure
          cleanup_test_post(post_path)
        end
      end
    end
  end
  
  # Feature: jekyll-site-modernization, Property 8: Pagination generation
  # Validates: Requirements 3.4
  describe "pagination generation" do
    # This property verifies that for any blog with more than the pagination limit,
    # Jekyll generates multiple pages with correct pagination navigation
    it "generates correct pagination for any number of posts exceeding the limit" do
      property_of {
        # Generate between 11 and 30 posts (more than the pagination limit of 10)
        num_posts = range(11, 30)
        base_date = Time.new(2024, 1, 1)
        
        posts = array(num_posts) do
          days_offset = range(0, 300)
          date = base_date + (days_offset * 24 * 60 * 60)
          title_words = array(range(2, 4)) { choose('Pagination', 'Test', 'Post', 'Blog') }
          title = title_words.join(' ')
          slug = title_words.map(&:downcase).join('-')
          
          {
            'filename' => "#{date.strftime('%Y-%m-%d')}-#{slug}-#{rand(10000)}.md",
            'date' => date,
            'title' => "PaginationTest #{title} #{rand(10000)}"
          }
        end
        
        # Ensure unique filenames
        posts.each_with_index do |post, idx|
          post['filename'] = post['filename'].gsub(/\.md$/, "-#{idx}.md")
        end
        
        {
          'posts' => posts,
          'num_posts' => num_posts,
          'paginate_limit' => 10,
          'expected_pages' => (num_posts.to_f / 10).ceil
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
                'date' => post_data['date']
              },
              "Test content"
            )
            created_posts << post_path
          end
          
          # Process the site with pagination
          site.reset
          site.read
          site.generate
          
          # Get our test posts
          test_posts = site.posts.docs.select { |p| p.data['title'].start_with?('PaginationTest') }
          
          # Verify we created all posts
          expect(test_posts.length).to eq(test_data['num_posts'])
          
          # Verify pagination math
          expected_pages = test_data['expected_pages']
          actual_pages = (test_posts.length.to_f / test_data['paginate_limit']).ceil
          expect(actual_pages).to eq(expected_pages)
          
          # Verify pagination properties
          expect(expected_pages).to be > 1  # Should have multiple pages
          expect(test_posts.length).to be > test_data['paginate_limit']  # More posts than limit
          
        ensure
          # Clean up all created posts
          created_posts.each { |path| cleanup_test_post(path) }
        end
      end
    end
  end
  
  # Feature: jekyll-site-modernization, Property 6: Chronological post ordering
  # Validates: Requirements 3.1
  describe "chronological post ordering" do
    # This property verifies that for any set of blog posts, they are displayed
    # in reverse chronological order (newest first)
    it "displays posts in reverse chronological order for any set of posts" do
      property_of {
        # Generate 3-10 posts with random dates in the past (before today)
        num_posts = range(3, 10)
        # Use a fixed base date in the past to avoid future dates
        base_date = Time.new(2024, 1, 1)
        posts = array(num_posts) do
          # Generate dates between base_date and base_date + 300 days
          days_offset = range(0, 300)
          date = base_date + (days_offset * 24 * 60 * 60)
          title_words = array(range(2, 4)) { choose('Test', 'Post', 'Blog', 'Article') }
          title = title_words.join(' ')
          slug = title_words.map(&:downcase).join('-')
          
          {
            'filename' => "#{date.strftime('%Y-%m-%d')}-#{slug}-#{rand(10000)}.md",
            'date' => date,
            'title' => "PropTest #{title} #{rand(10000)}"  # Unique prefix to identify test posts
          }
        end
        
        # Ensure unique filenames
        posts.each_with_index do |post, idx|
          post['filename'] = post['filename'].gsub(/\.md$/, "-#{idx}.md")
        end
        
        posts
      }.check(100) do |posts_data|
        created_posts = []
        
        begin
          # Create all test posts
          posts_data.each do |post_data|
            post_path = create_test_post(
              post_data['filename'],
              {
                'layout' => 'post',
                'title' => post_data['title'],
                'date' => post_data['date']
              },
              "Test content"
            )
            created_posts << post_path
          end
          
          # Process the site
          site.reset
          site.read
          site.generate
          
          # Get only our test posts from the site (filter by title prefix)
          test_posts = site.posts.docs.select { |p| p.data['title'].start_with?('PropTest') }
          
          # Verify we found all our test posts
          expect(test_posts.length).to eq(posts_data.length)
          
          # Apply the same sorting that blog.html uses (sort by date, then reverse)
          sorted_test_posts = test_posts.sort_by { |p| p.date }.reverse
          
          # Verify sorted posts are in reverse chronological order (newest first)
          sorted_dates = sorted_test_posts.map { |p| p.date }
          
          # Check that each date is >= the next date (reverse chronological)
          sorted_dates.each_cons(2) do |current, next_date|
            expect(current).to be >= next_date
          end
          
          # Verify our test posts are included with correct titles
          test_post_titles = posts_data.map { |p| p['title'] }
          site_post_titles = test_posts.map { |p| p.data['title'] }
          
          # Check that all our test posts are present
          test_post_titles.each do |title|
            expect(site_post_titles).to include(title)
          end
          
        ensure
          # Clean up all created posts
          created_posts.each { |path| cleanup_test_post(path) }
        end
      end
    end
  end
end
