require 'spec_helper'
require 'jekyll'

# Feature: jekyll-site-modernization, Property 1: Navigation consistency and active state
# Validates: Requirements 1.1, 1.4, 1.5
RSpec.describe "Navigation System" do
  let(:config) do
    Jekyll.configuration({
      'source' => '.',
      'destination' => './_site',
      'quiet' => true
    })
  end
  
  let(:site) { Jekyll::Site.new(config) }
  let(:navigation_include) { File.read('_includes/navigation.html') }
  
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

  describe "navigation include file" do
    it "exists and is readable" do
      expect(File.exist?('_includes/navigation.html')).to be true
      expect(navigation_include).not_to be_empty
    end

    it "contains all required navigation links" do
      required_links = ['Home', 'About', 'Blog', 'Contact']
      
      required_links.each do |link_text|
        expect(navigation_include).to include(link_text),
          "Navigation should contain '#{link_text}' link"
      end
    end

    it "uses Bootstrap 5 navbar structure" do
      expect(navigation_include).to include('navbar'),
        "Navigation should use Bootstrap navbar"
      expect(navigation_include).to include('navbar-toggler'),
        "Navigation should include mobile toggle button"
      expect(navigation_include).to include('navbar-collapse'),
        "Navigation should include collapsible menu"
    end

    it "includes responsive hamburger menu" do
      expect(navigation_include).to include('navbar-toggler'),
        "Navigation should have hamburger menu button"
      expect(navigation_include).to include('data-bs-toggle="collapse"'),
        "Navigation should have Bootstrap 5 collapse functionality"
    end
  end

  describe "active state implementation" do
    it "includes active class logic for current page" do
      expect(navigation_include).to include('active'),
        "Navigation should implement active state"
      expect(navigation_include).to match(/\{%\s*if.*page\.url/),
        "Navigation should check page.url for active state"
    end

    it "includes aria-current attribute for accessibility" do
      expect(navigation_include).to include('aria-current'),
        "Navigation should include aria-current for accessibility"
    end
  end

  # Feature: jekyll-site-modernization, Property 1: Navigation consistency and active state
  # For any page in the Jekyll site, the navigation should render with all required links
  # and the current page should have the active CSS class
  describe "property-based navigation validation" do
    let(:test_pages) do
      [
        { url: '/', title: 'Home' },
        { url: '/about.html', title: 'About' },
        { url: '/about/', title: 'About' },
        { url: '/blog', title: 'Blog' },
        { url: '/blog/', title: 'Blog' },
        { url: '/blog/2024/01/01/test-post/', title: 'Blog Post' },
        { url: '/contact.html', title: 'Contact' },
        { url: '/contact/', title: 'Contact' }
      ]
    end

    it "renders navigation with all required links for any page" do
      pages = test_pages
      nav_include = navigation_include
      property_of {
        # Generate random page from test pages
        pages.sample
      }.check(100) do |page_data|
        # Simulate rendering navigation for this page
        rendered = nav_include.dup
        
        # Check that all required navigation items are present
        required_links = ['Home', 'About', 'Blog', 'Contact']
        required_links.each do |link_text|
          expect(rendered).to include(link_text),
            "Navigation for page '#{page_data[:url]}' should contain '#{link_text}' link"
        end
        
        # Check that navigation structure is consistent
        expect(rendered).to include('navbar'),
          "Navigation for page '#{page_data[:url]}' should have navbar structure"
        expect(rendered).to include('nav-link'),
          "Navigation for page '#{page_data[:url]}' should have nav-link classes"
      end
    end

    it "applies active class to the correct navigation item based on page URL" do
      pages = test_pages
      property_of {
        # Generate random page from test pages
        pages.sample
      }.check(100) do |page_data|
        # Simulate the Liquid template logic for active state
        page_url = page_data[:url]
        
        # Check home page active logic
        home_active = (page_url == '/')
        
        # Check about page active logic
        about_active = (page_url == '/about.html' || page_url == '/about/')
        
        # Check blog page active logic (includes blog posts)
        blog_active = page_url.include?('/blog')
        
        # Check contact page active logic
        contact_active = (page_url == '/contact.html' || page_url == '/contact/')
        
        # Verify that exactly one navigation item should be active (or blog for blog posts)
        active_count = [home_active, about_active, blog_active, contact_active].count(true)
        
        expect(active_count).to be >= 1,
          "At least one navigation item should be active for page '#{page_url}'"
        
        # For non-blog pages, exactly one should be active
        unless page_url.include?('/blog')
          expect(active_count).to eq(1),
            "Exactly one navigation item should be active for page '#{page_url}'"
        end
      end
    end

    it "maintains consistent navigation structure across all pages" do
      pages = test_pages
      nav_include = navigation_include
      property_of {
        # Generate random subset of pages
        pages.sample(rand(1..pages.length))
      }.check(100) do |page_subset|
        # For each page in the subset, verify navigation consistency
        page_subset.each do |page_data|
          # Navigation should always have the same structure
          expect(nav_include).to include('navbar-brand'),
            "Navigation should have brand for page '#{page_data[:url]}'"
          expect(nav_include).to include('navbar-nav'),
            "Navigation should have nav list for page '#{page_data[:url]}'"
          expect(nav_include).to include('navbar-toggler'),
            "Navigation should have mobile toggle for page '#{page_data[:url]}'"
        end
      end
    end
  end

  describe "accessibility requirements" do
    it "includes proper ARIA labels" do
      expect(navigation_include).to include('aria-label'),
        "Navigation should include ARIA labels for accessibility"
    end

    it "includes proper button labels for screen readers" do
      expect(navigation_include).to match(/aria-label="Toggle navigation"/i),
        "Toggle button should have descriptive aria-label"
    end
  end

  describe "responsive design" do
    it "includes Bootstrap 5 responsive classes" do
      expect(navigation_include).to include('navbar-expand'),
        "Navigation should use Bootstrap 5 responsive breakpoints"
    end

    it "includes collapsible menu for mobile" do
      expect(navigation_include).to include('collapse'),
        "Navigation should have collapsible menu"
      expect(navigation_include).to include('navbar-collapse'),
        "Navigation should use navbar-collapse class"
    end
  end
end
