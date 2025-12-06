# Implementation Plan

- [x] 1. Set up project structure and configuration





  - Create new directory structure (assets/, _layouts/, _includes/, _data/)
  - Update _config.yml with modern Jekyll configuration, pagination, and color scheme
  - Create Gemfile with github-pages gem and testing dependencies
  - Update .gitignore for Jekyll build artifacts
  - _Requirements: 6.1, 6.2, 6.4, 6.5, 12.1, 12.4_

- [x] 1.1 Write property test for GitHub Pages plugin compatibility



  - **Property 14: GitHub Pages plugin compatibility**
  - **Validates: Requirements 6.1**

- [x] 2. Create base layout and navigation system





  - Create _layouts/default.html with modern HTML5 structure
  - Create _includes/head.html with meta tags, SEO tags, and asset links
  - Create _includes/navigation.html with Bootstrap 5 navbar
  - Create _includes/footer.html with social links
  - Implement active page highlighting in navigation
  - _Requirements: 1.1, 1.4, 1.5, 5.1, 7.5, 10.1, 10.5_

- [x] 2.1 Write property test for navigation consistency and active state



  - **Property 1: Navigation consistency and active state**
  - **Validates: Requirements 1.1, 1.4, 1.5**

- [x] 2.2 Write property test for semantic HTML structure



  - **Property 15: Semantic HTML structure**
  - **Validates: Requirements 7.5**

- [x] 2.3 Write property test for meta tag completeness



  - **Property 20: Meta tag completeness**
  - **Validates: Requirements 10.1, 10.4**

- [x] 3. Migrate and create core pages






  - Create index.html as landing/home page
  - Create about.html with About Me content from _includes/about_me.html
  - Create contact.html with contact form from _includes/contact_form.html
  - Create _layouts/page.html for standard pages
  - Update content to use modern Bootstrap 5 classes
  - _Requirements: 8.1, 8.2, 8.3, 5.1_

- [x] 4. Implement blog post system





  - Create _layouts/post.html for individual blog posts
  - Implement post metadata display (title, date, author, categories, tags)
  - Add reading time calculation using Liquid
  - Add previous/next post navigation
  - Implement syntax highlighting with Rouge
  - Add responsive image classes
  - Add lazy loading attributes to images
  - _Requirements: 2.3, 2.4, 2.5, 4.1, 4.2, 4.3, 4.4, 4.5, 7.3_

- [x] 4.1 Write property test for post metadata rendering


  - **Property 3: Post metadata rendering**
  - **Validates: Requirements 2.3, 4.1**

- [x] 4.2 Write property test for permalink generation


  - **Property 4: Permalink generation**
  - **Validates: Requirements 2.4**

- [x] 4.3 Write property test for markdown rendering


  - **Property 5: Markdown rendering**
  - **Validates: Requirements 2.5**

- [x] 4.4 Write property test for syntax highlighting

  - **Property 10: Syntax highlighting application**
  - **Validates: Requirements 4.2**

- [x] 4.5 Write property test for responsive image attributes

  - **Property 11: Responsive image attributes**
  - **Validates: Requirements 4.3, 7.3**

- [x] 4.6 Write property test for post navigation links

  - **Property 12: Post navigation links**
  - **Validates: Requirements 4.4**

- [x] 4.7 Write property test for reading time calculation

  - **Property 13: Reading time calculation**
  - **Validates: Requirements 4.5**

- [x] 5. Create blog listing and pagination





  - Create blog.html with post listing
  - Create _includes/post-card.html for post preview cards
  - Implement pagination using jekyll-paginate
  - Add pagination navigation controls
  - Ensure posts display in reverse chronological order
  - _Requirements: 2.1, 2.2, 3.1, 3.2, 3.3, 3.4_

- [x] 5.1 Write property test for post collection inclusion


  - **Property 2: Post collection inclusion**
  - **Validates: Requirements 2.1, 2.2**

- [x] 5.2 Write property test for chronological post ordering


  - **Property 6: Chronological post ordering**
  - **Validates: Requirements 3.1**

- [x] 5.3 Write property test for post card completeness


  - **Property 7: Post card completeness**
  - **Validates: Requirements 3.2, 3.3**

- [x] 5.4 Write property test for pagination generation


  - **Property 8: Pagination generation**
  - **Validates: Requirements 3.4**

- [x] 6. Implement category and tag system





  - Create category pages (one per category)
  - Create tag pages (one per tag)
  - Create _includes/category-list.html for category navigation
  - Create _includes/tag-cloud.html for tag display
  - Add category and tag links to post cards and post pages
  - Ensure filtered pages use same layout as main blog
  - _Requirements: 3.5, 9.1, 9.2, 9.3, 9.4, 9.5_

- [x] 6.1 Write property test for taxonomy link generation


  - **Property 9: Taxonomy link generation**
  - **Validates: Requirements 3.5**

- [x] 6.2 Write property test for category filtering accuracy


  - **Property 16: Category filtering accuracy**
  - **Validates: Requirements 9.1**

- [x] 6.3 Write property test for tag filtering accuracy


  - **Property 17: Tag filtering accuracy**
  - **Validates: Requirements 9.2**

- [x] 6.4 Write property test for complete taxonomy lists


  - **Property 18: Complete taxonomy lists**
  - **Validates: Requirements 9.3, 9.4**

- [x] 6.5 Write property test for taxonomy layout consistency


  - **Property 19: Taxonomy layout consistency**
  - **Validates: Requirements 9.5**

- [x] 7. Implement canonical URL support





  - Add canonical link tag logic to _includes/head.html
  - Create conditional logic for custom vs. default canonical URLs
  - Add "originally published" notice to post layout
  - Update RSS feed template to include canonical URLs
  - Ensure full content displays regardless of canonical URL
  - _Requirements: 11.1, 11.2, 11.3, 11.4, 11.5_

- [x] 7.1 Write property test for canonical URL with external source


  - **Property 21: Canonical URL with external source**
  - **Validates: Requirements 11.1, 11.2**

- [x] 7.2 Write property test for canonical URL default behavior


  - **Property 22: Canonical URL default behavior**
  - **Validates: Requirements 11.3**

- [x] 7.3 Write property test for canonical URL in RSS feed


  - **Property 23: Canonical URL in RSS feed**
  - **Validates: Requirements 11.4**

- [x] 7.4 Write property test for content completeness with canonical URL


  - **Property 24: Content completeness with canonical URL**
  - **Validates: Requirements 11.5**

- [x] 8. Implement modern styling with Bootstrap 5





  - Remove Bootstrap 3 CSS and jQuery dependencies
  - Add Bootstrap 5 CSS and JavaScript (via CDN or local)
  - Create custom CSS file with color scheme variables
  - Update all HTML to use Bootstrap 5 classes
  - Implement responsive design for mobile, tablet, desktop
  - Remove jQuery from existing JavaScript files
  - Rewrite JavaScript using vanilla ES6+
  - _Requirements: 5.1, 5.2, 5.3, 5.4, 5.5, 12.1, 12.2, 12.3, 12.4_

- [x] 8.1 Write property test for color contrast accessibility


  - **Property 25: Color contrast accessibility**
  - **Validates: Requirements 12.2**

- [x] 8.2 Write property test for color palette consistency


  - **Property 26: Color palette consistency**
  - **Validates: Requirements 12.3**

- [x] 9. Set up SEO and feeds
  - Configure jekyll-seo-tag plugin
  - Configure jekyll-sitemap plugin
  - Configure jekyll-feed plugin for RSS
  - Add Open Graph meta tags
  - Verify Google and Bing verification codes are preserved
  - _Requirements: 10.1, 10.2, 10.3, 10.4, 10.5_

- [x] 10. Create sample blog posts





  - Create 3-5 sample blog posts with varied content
  - Include posts with and without canonical URLs
  - Include posts with different categories and tags
  - Include posts with code blocks, images, and various markdown elements
  - Test posts with edge cases (long titles, special characters, etc.)
  - _Requirements: 2.1, 2.2, 2.3, 2.5_

- [x] 11. Update documentation





  - Update README.md with project overview
  - Add local development setup instructions
  - Document Ruby version requirements
  - Add bundle install command
  - Add jekyll serve command with live reload
  - Document how to create new blog posts
  - Document front matter options
  - Add troubleshooting section
  - _Requirements: 13.1, 13.2, 13.3, 13.4_

- [x] 12. Checkpoint - Ensure all tests pass





  - Ensure all tests pass, ask the user if questions arise.

- [x] 13. Optimize assets and performance





  - Minify CSS files
  - Minify JavaScript files
  - Optimize images in img/ directory
  - Verify lazy loading implementation
  - Test with Lighthouse for performance score
  - _Requirements: 7.1, 7.2, 7.3_

- [x] 13.1 Run HTML validation tests


  - Use HTMLProofer to validate generated HTML
  - Check for broken links
  - Verify image alt text
  - Verify heading hierarchy

- [x] 13.2 Run accessibility tests


  - Test color contrast ratios
  - Test keyboard navigation
  - Verify ARIA labels
  - Test with screen reader

- [x] 14. Final testing and validation





  - Build site with `bundle exec jekyll build`
  - Test all pages locally
  - Verify navigation works on all pages
  - Test blog pagination
  - Test category and tag filtering
  - Test contact form submission
  - Test responsive design on mobile devices
  - Verify GitHub Pages compatibility
  - _Requirements: 6.3_

- [x] 15. Final Checkpoint - Ensure all tests pass





  - Ensure all tests pass, ask the user if questions arise.
