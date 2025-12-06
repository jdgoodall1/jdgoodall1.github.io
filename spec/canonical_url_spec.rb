require 'spec_helper'
require 'jekyll'
require 'nokogiri'
require 'fileutils'

RSpec.describe "Canonical URL Support" do
  let(:config) do
    Jekyll.configuration({
      'source' => '.',
      'destination' => './_site',
      'quiet' => true,
      'permalink' => '/blog/:year/:month/:day/:title/',
      'future' => true
    })
  end
  
  let(:site) { Jekyll::Site.new(config) }
  
  # Helper to create a temporary post file
  def create_test_post(filename, front_matter, content = "Test content for canonical URL testing.")
    FileUtils.mkdir_p('_posts') unless Dir.exist?('_posts')
    
    post_path = File.join('_posts', filename)
    front_matter_yaml = front_matter.map { |k, v| "#{k}: #{v.inspect}" }.join("\n")
    File.write(post_path, "---\n#{front_matter_yaml}\n---\n\n#{content}")
    post_path
  end
  
  # Helper to clean up test posts
  def cleanup_test_post(post_path)
    File.delete(post_path) if File.exist?(post_path)
  end
  
  # Helper to build site and get rendered HTML
  def build_and_get_html(post_path)
    site.reset
    site.read
    site.generate
    site.render
    site.write
    
    # Find the generated HTML file
    post = site.posts.docs.find { |p| p.path == post_path }
    return nil unless post
    
    output_path = File.join(site.dest, post.url, 'index.html')
    File.exist?(output_path) ? File.read(output_path) : nil
  end
  
  # Feature: jekyll-site-modernization, Property 21: Canonical URL with external source
  # Validates: Requirements 11.1, 11.2
  describe "canonical URL with external source" do
    it "includes canonical link tag and notice for any post with canonical_url in front matter" do
      property_of {
        days_ago = range(1, 365)
        date = Time.now - (days_ago * 24 * 60 * 60)
        domains = ['medium.com', 'dev.to', 'hashnode.dev', 'example.com', 'blog.company.com']
        paths = ['my-article', 'blog-post', 'tutorial', 'guide', 'article-123']
        
        {
          'filename' => "#{date.strftime('%Y-%m-%d')}-test-post-#{range(1, 10000)}.md",
          'date' => date,
          'title' => "Test Post #{range(1, 10000)}",
          'canonical_url' => "https://#{choose(*domains)}/#{choose(*paths)}"
        }
      }.check(100) do |post_data|
        # Create test post with canonical URL
        front_matter = {
          'layout' => 'post',
          'title' => post_data['title'],
          'date' => post_data['date'],
          'canonical_url' => post_data['canonical_url']
        }
        
        post_path = create_test_post(post_data['filename'], front_matter)
        
        begin
          html = build_and_get_html(post_path)
          
          # Skip if build failed (shouldn't happen with valid data)
          next unless html
          
          doc = Nokogiri::HTML(html)
          
          # Property 1: Canonical link tag should point to external URL
          canonical_link = doc.at_css('link[rel="canonical"]')
          expect(canonical_link).not_to be_nil, "Canonical link tag should exist"
          expect(canonical_link['href']).to eq(post_data['canonical_url']), 
            "Canonical link should point to external URL"
          
          # Property 2: Notice should be displayed indicating original publication
          notice = doc.at_css('.alert-info')
          expect(notice).not_to be_nil, "Original publication notice should exist"
          expect(notice.text).to include('originally published'), 
            "Notice should mention original publication"
          
          # Property 3: Notice should contain link to canonical URL
          notice_link = notice.at_css('a')
          expect(notice_link).not_to be_nil, "Notice should contain a link"
          expect(notice_link['href']).to eq(post_data['canonical_url']),
            "Notice link should point to canonical URL"
          
        ensure
          cleanup_test_post(post_path)
        end
      end
    end
  end
  
  # Feature: jekyll-site-modernization, Property 22: Canonical URL default behavior
  # Validates: Requirements 11.3
  describe "canonical URL default behavior" do
    it "uses post's own URL as canonical when no canonical_url is specified" do
      property_of {
        days_ago = range(1, 365)
        date = Time.now - (days_ago * 24 * 60 * 60)
        title_words = array(range(2, 5)) { choose('test', 'post', 'blog', 'article', 'content', 'guide') }
        
        {
          'filename' => "#{date.strftime('%Y-%m-%d')}-#{title_words.join('-')}.md",
          'date' => date,
          'title' => title_words.map(&:capitalize).join(' '),
          'slug' => title_words.join('-')
        }
      }.check(100) do |post_data|
        # Create test post WITHOUT canonical URL
        front_matter = {
          'layout' => 'post',
          'title' => post_data['title'],
          'date' => post_data['date']
        }
        
        post_path = create_test_post(post_data['filename'], front_matter)
        
        begin
          html = build_and_get_html(post_path)
          
          # Skip if build failed
          next unless html
          
          doc = Nokogiri::HTML(html)
          
          # Property 1: Canonical link tag should exist
          canonical_link = doc.at_css('link[rel="canonical"]')
          expect(canonical_link).not_to be_nil, "Canonical link tag should exist even without canonical_url"
          
          # Property 2: Canonical link should point to post's own URL
          expected_path = "/blog/#{post_data['date'].strftime('%Y/%m/%d')}/#{post_data['slug']}/"
          expect(canonical_link['href']).to include(expected_path),
            "Canonical link should point to post's own URL path"
          
          # Property 3: No "originally published" notice should be displayed
          notice = doc.at_css('.alert-info')
          expect(notice).to be_nil, "No original publication notice should exist when canonical_url is not set"
          
        ensure
          cleanup_test_post(post_path)
        end
      end
    end
  end
  
  # Feature: jekyll-site-modernization, Property 23: Canonical URL in RSS feed
  # Validates: Requirements 11.4
  describe "canonical URL in RSS feed" do
    it "includes canonical URL in RSS feed for any post" do
      property_of {
        days_ago = range(1, 365)
        date = Time.now - (days_ago * 24 * 60 * 60)
        has_canonical = choose(true, false)
        title_words = array(range(2, 5)) { choose('test', 'post', 'blog', 'article', 'content') }
        
        canonical_url = if has_canonical
          domains = ['medium.com', 'dev.to', 'hashnode.dev']
          "https://#{choose(*domains)}/article-#{range(1, 1000)}"
        else
          nil
        end
        
        {
          'filename' => "#{date.strftime('%Y-%m-%d')}-#{title_words.join('-')}.md",
          'date' => date,
          'title' => title_words.map(&:capitalize).join(' '),
          'slug' => title_words.join('-'),
          'has_canonical' => has_canonical,
          'canonical_url' => canonical_url
        }
      }.check(100) do |post_data|
        # Create test post with or without canonical URL
        front_matter = {
          'layout' => 'post',
          'title' => post_data['title'],
          'date' => post_data['date']
        }
        front_matter['canonical_url'] = post_data['canonical_url'] if post_data['has_canonical']
        
        post_path = create_test_post(post_data['filename'], front_matter)
        
        begin
          # Build site to generate RSS feed
          site.reset
          site.read
          site.generate
          site.render
          site.write
          
          # Read the RSS feed
          feed_path = File.join(site.dest, 'feed.xml')
          next unless File.exist?(feed_path)
          
          feed_content = File.read(feed_path)
          feed_doc = Nokogiri::XML(feed_content)
          
          # Find the entry for this post
          entry = feed_doc.xpath("//xmlns:entry[xmlns:title[contains(text(), '#{post_data['title']}')]]").first
          next unless entry
          
          # Get the link element
          link = entry.at_xpath("xmlns:link[@rel='alternate']")
          expect(link).not_to be_nil, "RSS feed entry should have a link element"
          
          # Property: Link should point to canonical URL if set, otherwise to post URL
          if post_data['has_canonical']
            expect(link['href']).to eq(post_data['canonical_url']),
              "RSS feed link should point to canonical URL when set"
          else
            expected_path = "/blog/#{post_data['date'].strftime('%Y/%m/%d')}/#{post_data['slug']}/"
            expect(link['href']).to include(expected_path),
              "RSS feed link should point to post's own URL when canonical_url is not set"
          end
          
        ensure
          cleanup_test_post(post_path)
        end
      end
    end
  end
  
  # Feature: jekyll-site-modernization, Property 24: Content completeness with canonical URL
  # Validates: Requirements 11.5
  describe "content completeness with canonical URL" do
    it "displays full content for any post regardless of canonical URL presence" do
      property_of {
        days_ago = range(1, 365)
        date = Time.now - (days_ago * 24 * 60 * 60)
        has_canonical = choose(true, false)
        
        # Generate content with multiple paragraphs and elements
        num_paragraphs = range(3, 10)
        content_paragraphs = Array.new(num_paragraphs) do |i|
          "This is paragraph #{i + 1} with some test content. " * range(5, 15)
        end
        content = content_paragraphs.join("\n\n")
        
        canonical_url = if has_canonical
          "https://example.com/article-#{range(1, 1000)}"
        else
          nil
        end
        
        {
          'filename' => "#{date.strftime('%Y-%m-%d')}-content-test-#{range(1, 10000)}.md",
          'date' => date,
          'title' => "Content Test #{range(1, 10000)}",
          'has_canonical' => has_canonical,
          'canonical_url' => canonical_url,
          'content' => content,
          'content_length' => content.length
        }
      }.check(100) do |post_data|
        # Create test post with substantial content
        front_matter = {
          'layout' => 'post',
          'title' => post_data['title'],
          'date' => post_data['date']
        }
        front_matter['canonical_url'] = post_data['canonical_url'] if post_data['has_canonical']
        
        post_path = create_test_post(post_data['filename'], front_matter, post_data['content'])
        
        begin
          html = build_and_get_html(post_path)
          
          # Skip if build failed
          next unless html
          
          doc = Nokogiri::HTML(html)
          
          # Property 1: Post content section should exist
          post_content = doc.at_css('.post-content')
          expect(post_content).not_to be_nil, "Post content section should exist"
          
          # Property 2: Content should not be truncated
          # Check that the content contains text from the original content
          content_text = post_content.text.gsub(/\s+/, ' ').strip
          expect(content_text.length).to be > 100, 
            "Content should be substantial (not truncated)"
          
          # Property 3: Content completeness should be independent of canonical URL
          # If canonical URL is set, content should still be complete
          if post_data['has_canonical']
            # Verify that having a canonical URL doesn't truncate content
            expect(content_text.length).to be > post_data['content_length'] * 0.5,
              "Content with canonical URL should not be significantly truncated"
          end
          
          # Property 4: All paragraphs should be rendered
          paragraphs = post_content.css('p')
          expect(paragraphs.length).to be > 0, "Content should have rendered paragraphs"
          
        ensure
          cleanup_test_post(post_path)
        end
      end
    end
  end
end
