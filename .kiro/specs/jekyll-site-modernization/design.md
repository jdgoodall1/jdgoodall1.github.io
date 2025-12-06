# Design Document

## Overview

This design document outlines the modernization of a single-page Jekyll portfolio website into a multi-page site with an integrated blog system. The solution maintains compatibility with GitHub Pages free hosting while updating dependencies, improving the visual design, and adding comprehensive blogging capabilities.

The modernization follows a progressive enhancement approach: we'll restructure the site architecture to support multiple pages, implement a blog system using Jekyll's native collections, update the frontend stack to modern standards (Bootstrap 5, vanilla JavaScript), and enhance the visual design with a contemporary color scheme.

## Architecture

### Site Structure

The site will transition from a single-page application to a multi-page structure:

```
/
├── index.html          # Home/landing page
├── about.html          # About page
├── blog.html           # Blog listing page
├── contact.html        # Contact page
├── _posts/             # Blog post markdown files
│   └── YYYY-MM-DD-title.md
├── _layouts/           # Layout templates
│   ├── default.html    # Base layout
│   ├── page.html       # Standard page layout
│   ├── post.html       # Blog post layout
│   └── blog.html       # Blog listing layout
├── _includes/          # Reusable components
│   ├── head.html
│   ├── header.html
│   ├── footer.html
│   ├── navigation.html
│   └── post-card.html
├── assets/             # Static assets
│   ├── css/
│   ├── js/
│   └── images/
└── _config.yml         # Jekyll configuration
```

### Technology Stack

- **Static Site Generator**: Jekyll 3.9+ (GitHub Pages compatible)
- **CSS Framework**: Bootstrap 5.3
- **JavaScript**: Vanilla ES6+ (no jQuery)
- **Icons**: Bootstrap Icons or Font Awesome 6
- **Syntax Highlighting**: Rouge (Jekyll default)
- **Build Tool**: Jekyll with Bundler
- **Hosting**: GitHub Pages

### Jekyll Configuration

The `_config.yml` will be updated to support:
- Pagination for blog posts
- Collections configuration
- Permalink structure
- Plugin configuration (GitHub Pages whitelist only)
- Site metadata and SEO settings

## Components and Interfaces

### Navigation Component

A responsive navigation bar that appears on all pages:

**Features:**
- Logo/site title linking to home
- Navigation links: Home, About, Blog, Contact
- Active page highlighting
- Mobile-responsive hamburger menu
- Smooth scroll for anchor links on single pages

**Implementation:**
- Bootstrap 5 navbar component
- Vanilla JavaScript for mobile toggle
- CSS classes for active state
- Liquid templating for dynamic active state detection

### Blog Listing Component

Displays paginated list of blog posts:

**Features:**
- Post cards showing title, date, excerpt, categories, tags
- Pagination controls (previous/next, page numbers)
- Category and tag filters
- Responsive grid layout (1 column mobile, 2-3 columns desktop)

**Implementation:**
- Jekyll pagination plugin (jekyll-paginate-v2 or built-in)
- Liquid loops for post iteration
- Bootstrap grid system
- Post excerpt generation

### Blog Post Component

Individual blog post display:

**Features:**
- Post metadata (title, date, author, reading time)
- Full post content with markdown rendering
- Syntax highlighting for code blocks
- Previous/next post navigation
- Category and tag display
- Canonical URL notice (if applicable)
- Social sharing buttons

**Implementation:**
- Custom post layout template
- Rouge syntax highlighter
- Reading time calculation via Liquid
- Canonical link in HTML head

### Category/Tag Filter System

Allows filtering posts by taxonomy:

**Features:**
- Category pages (one per category)
- Tag pages (one per tag)
- Category list in sidebar/header
- Tag cloud visualization

**Implementation:**
- Jekyll category and tag pages
- Liquid loops to generate taxonomy pages
- CSS for tag cloud sizing based on post count


### Contact Form Component

Contact form with validation:

**Features:**
- Name, email, message fields
- Client-side validation
- Form submission via Formspree (existing)
- Success/error messaging

**Implementation:**
- Bootstrap form components
- Vanilla JavaScript validation
- Formspree integration (already configured)

## Data Models

### Post Front Matter

Each blog post markdown file includes YAML front matter:

```yaml
---
layout: post
title: "Post Title"
date: 2024-12-06
author: Jon Goodall
categories: [DevOps, AWS]
tags: [terraform, automation, cloud]
excerpt: "Brief description of the post"
canonical_url: "https://example.com/original-post"  # Optional
image: "/assets/images/post-image.jpg"  # Optional
---
```

### Site Configuration

The `_config.yml` contains site-wide settings:

```yaml
title: Jon Goodall
email: jongoodall14@gmail.com
description: Senior Cloud Engineer specializing in DevOps and AWS
baseurl: ""
url: "https://jdgoodall1.github.io"

# Build settings
markdown: kramdown
highlighter: rouge
permalink: /blog/:year/:month/:day/:title/

# Pagination
paginate: 10
paginate_path: "/blog/page:num/"

# Collections
collections:
  posts:
    output: true
    permalink: /blog/:year/:month/:day/:title/

# Plugins (GitHub Pages whitelist)
plugins:
  - jekyll-feed
  - jekyll-seo-tag
  - jekyll-sitemap
  - jekyll-paginate

# Social links
social:
  linkedin: https://www.linkedin.com/in/jdgoodall1/
  github: https://github.com/jdgoodall1
  medium: https://medium.com/@jdgoodall1

# SEO
google_verify: L2VsLI1uLyBPXQKO65ErOx1V5NYRQstKixSdR4HQW60
bing_verify: 86AD1A2F130F4DC2271E097B4D65EBBF

# Color scheme
colors:
  primary: "#2563eb"      # Blue
  secondary: "#7c3aed"    # Purple
  accent: "#f59e0b"       # Amber
  text: "#1f2937"         # Dark gray
  background: "#ffffff"   # White
  light: "#f3f4f6"        # Light gray
```

### Navigation Data

Navigation items can be defined in `_data/navigation.yml`:

```yaml
- name: Home
  link: /
- name: About
  link: /about
- name: Blog
  link: /blog
- name: Contact
  link: /contact
```


## Correctness Properties

*A property is a characteristic or behavior that should hold true across all valid executions of a system-essentially, a formal statement about what the system should do. Properties serve as the bridge between human-readable specifications and machine-verifiable correctness guarantees.*

### Property 1: Navigation consistency and active state

*For any* page in the Jekyll site, the navigation component should render with all required links (Home, About, Blog, Contact) and the current page should have the active CSS class applied to its navigation item.

**Validates: Requirements 1.1, 1.4, 1.5**

### Property 2: Post collection inclusion

*For any* markdown file in the _posts directory with valid front matter and correct filename format (YYYY-MM-DD-title.md), the post should appear in the site.posts collection and be included in the blog listing page.

**Validates: Requirements 2.1, 2.2**

### Property 3: Post metadata rendering

*For any* blog post with front matter containing title, date, categories, and tags, the rendered post page HTML should contain all of these metadata fields in the appropriate locations.

**Validates: Requirements 2.3, 4.1**

### Property 4: Permalink generation

*For any* post in the _posts collection, Jekyll should generate an HTML file at the path specified by the permalink configuration, creating readable URLs.

**Validates: Requirements 2.4**

### Property 5: Markdown rendering

*For any* valid markdown syntax (code blocks, images, links, lists), the rendered HTML should contain the correct corresponding HTML elements with appropriate tags and attributes.

**Validates: Requirements 2.5**

### Property 6: Chronological post ordering

*For any* set of blog posts, the blog listing page should display them in reverse chronological order (newest first) based on the post date.

**Validates: Requirements 3.1**

### Property 7: Post card completeness

*For any* post displayed in the blog listing, the post card HTML should contain the title, publication date, excerpt, and a "Read More" link pointing to the correct post URL.

**Validates: Requirements 3.2, 3.3**

### Property 8: Pagination generation

*For any* blog with more than the configured pagination limit (e.g., 10 posts), Jekyll should generate multiple page files with correct pagination navigation links (previous, next, page numbers).

**Validates: Requirements 3.4**

### Property 9: Taxonomy link generation

*For any* post with categories or tags, the rendered post should include clickable links for each category and tag that point to the corresponding filter pages.

**Validates: Requirements 3.5**

### Property 10: Syntax highlighting application

*For any* code block in a post (using markdown code fence syntax), the rendered HTML should include syntax highlighting markup with appropriate CSS classes for the specified language.

**Validates: Requirements 4.2**

### Property 11: Responsive image attributes

*For any* image in post content, the rendered img tag should include responsive attributes (such as CSS classes or loading="lazy").

**Validates: Requirements 4.3, 7.3**

### Property 12: Post navigation links

*For any* blog post that is not the first or last post, the rendered post page should include previous and next navigation links pointing to the adjacent posts in chronological order.

**Validates: Requirements 4.4**

### Property 13: Reading time calculation

*For any* blog post, the rendered post page should display an estimated reading time calculated based on the word count (typically 200-250 words per minute).

**Validates: Requirements 4.5**

### Property 14: GitHub Pages plugin compatibility

*For any* plugin listed in the _config.yml plugins array, it should be present in the GitHub Pages supported plugins whitelist.

**Validates: Requirements 6.1**

### Property 15: Semantic HTML structure

*For any* page in the Jekyll site, the rendered HTML should use semantic HTML5 elements (header, nav, main, article, section, footer) appropriately for content structure.

**Validates: Requirements 7.5**

### Property 16: Category filtering accuracy

*For any* category filter page, all displayed posts should have that category in their front matter, and all posts with that category should be included.

**Validates: Requirements 9.1**

### Property 17: Tag filtering accuracy

*For any* tag filter page, all displayed posts should have that tag in their front matter, and all posts with that tag should be included.

**Validates: Requirements 9.2**

### Property 18: Complete taxonomy lists

*For any* page displaying categories or tags, the list should include all unique categories/tags that exist across all posts, with no duplicates.

**Validates: Requirements 9.3, 9.4**

### Property 19: Taxonomy layout consistency

*For any* category or tag filter page, the post listing should use the same post card template and layout as the main blog page.

**Validates: Requirements 9.5**

### Property 20: Meta tag completeness

*For any* page in the Jekyll site, the HTML head should contain required meta tags (title, description, keywords) and Open Graph tags (og:title, og:description, og:image, og:url).

**Validates: Requirements 10.1, 10.4**

### Property 21: Canonical URL with external source

*For any* blog post with a canonical_url field in front matter, the rendered HTML head should contain a canonical link tag pointing to that URL, and the post should display a notice indicating original publication location.

**Validates: Requirements 11.1, 11.2**

### Property 22: Canonical URL default behavior

*For any* blog post without a canonical_url field in front matter, the rendered HTML head should contain a canonical link tag pointing to the post's own URL.

**Validates: Requirements 11.3**

### Property 23: Canonical URL in RSS feed

*For any* post in the RSS feed, the feed entry should include the canonical URL (either from front matter or the post's own URL).

**Validates: Requirements 11.4**

### Property 24: Content completeness with canonical URL

*For any* blog post with a canonical_url field, the rendered post page should display the complete post content without truncation or restrictions.

**Validates: Requirements 11.5**

### Property 25: Color contrast accessibility

*For any* text and background color combination used in the site, the contrast ratio should meet WCAG AA standards (4.5:1 for normal text, 3:1 for large text).

**Validates: Requirements 12.2**

### Property 26: Color palette consistency

*For any* color value used in the site's CSS, it should match one of the defined color variables in the color palette (allowing for opacity variations).

**Validates: Requirements 12.3**


## Error Handling

### Build Errors

**Invalid Front Matter:**
- Jekyll should fail the build with a clear error message if post front matter is malformed YAML
- Error message should indicate the file and line number of the YAML error

**Missing Required Fields:**
- Posts without required front matter fields (title, date) should be excluded from the build with a warning
- The build should continue for other valid posts

**Invalid Permalink Configuration:**
- If permalink configuration results in conflicting URLs, Jekyll should fail the build with an error
- Error message should identify the conflicting posts

### Runtime Errors

**Missing Images:**
- If a post references an image that doesn't exist, the build should complete but log a warning
- The rendered page should display a broken image placeholder

**Invalid Liquid Syntax:**
- If a template contains invalid Liquid syntax, Jekyll should fail the build with an error
- Error message should indicate the file and line number

**Plugin Errors:**
- If a plugin fails during build, Jekyll should display the plugin name and error message
- Build should fail to prevent deploying broken site

### User Input Validation

**Contact Form:**
- Client-side validation should check for:
  - Non-empty name field
  - Valid email format
  - Non-empty message field
- Display inline error messages for invalid fields
- Prevent form submission until all fields are valid

**Search/Filter Input:**
- Handle empty search queries gracefully (show all posts or helpful message)
- Sanitize user input to prevent XSS attacks
- Handle special characters in search terms

## Testing Strategy

### Unit Testing

The Jekyll site will use a combination of unit tests and property-based tests to ensure correctness. Unit tests will focus on specific examples and edge cases, while property-based tests will verify universal properties across all inputs.

**Testing Framework:**
- **Ruby**: RSpec for testing Jekyll plugins and custom Ruby code
- **HTML Validation**: HTMLProofer gem for validating generated HTML
- **Accessibility**: Pa11y or axe-core for accessibility testing

**Unit Test Coverage:**

1. **Configuration Tests:**
   - Verify _config.yml contains required fields
   - Verify plugin list matches GitHub Pages whitelist
   - Verify permalink structure is valid

2. **Front Matter Tests:**
   - Test posts with minimal valid front matter
   - Test posts with all optional fields
   - Test posts with missing required fields (should be excluded)
   - Test posts with invalid YAML (should error)

3. **Edge Cases:**
   - Post with empty content
   - Post with very long title
   - Post with special characters in title
   - Post with future date
   - Post with no categories or tags
   - Post with canonical URL
   - Post without canonical URL

4. **HTML Validation:**
   - Validate generated HTML for all page types
   - Check for broken links
   - Verify all images have alt text
   - Verify proper heading hierarchy

5. **Accessibility Tests:**
   - Color contrast ratios
   - Keyboard navigation
   - Screen reader compatibility
   - ARIA labels

### Property-Based Testing

Property-based testing will verify that universal properties hold across all valid inputs. We'll use RSpec with the rantly gem for property-based testing in Ruby.

**Property Test Configuration:**
- Each property test should run a minimum of 100 iterations
- Each test must be tagged with a comment referencing the design document property
- Tag format: `# Feature: jekyll-site-modernization, Property {number}: {property_text}`

**Property Test Coverage:**

Each correctness property listed in the Correctness Properties section should be implemented as a property-based test. The tests will generate random valid inputs (posts, pages, configurations) and verify that the properties hold.

**Example Property Test Structure:**

```ruby
# Feature: jekyll-site-modernization, Property 2: Post collection inclusion
RSpec.describe "Post collection" do
  it "includes all valid posts in site.posts" do
    property_of {
      # Generate random post with valid front matter and filename
      generate_random_post
    }.check(100) { |post|
      # Build site with this post
      site = build_site_with_post(post)
      
      # Verify post appears in collection
      expect(site.posts.map(&:title)).to include(post.title)
    }
  end
end
```

**Test Execution:**
- Tests should run on every commit via GitHub Actions
- Tests should run locally before pushing changes
- Failed tests should block deployment

### Integration Testing

**Build Testing:**
- Test complete site build with sample content
- Verify all pages generate successfully
- Check for build warnings and errors
- Validate output directory structure

**GitHub Pages Compatibility:**
- Test build using github-pages gem (same as GitHub uses)
- Verify no unsupported plugins or features
- Test with same Ruby version as GitHub Pages

**Cross-Browser Testing:**
- Manual testing on Chrome, Firefox, Safari, Edge
- Test responsive design on mobile devices
- Verify JavaScript functionality across browsers

### Performance Testing

**Build Performance:**
- Measure build time with varying numbers of posts (10, 50, 100, 500)
- Identify performance bottlenecks
- Optimize slow builds

**Page Load Performance:**
- Use Lighthouse for performance audits
- Target: Performance score > 90
- Measure First Contentful Paint (FCP)
- Measure Time to Interactive (TTI)

**Asset Optimization:**
- Verify CSS and JS are minified
- Check image file sizes
- Verify lazy loading implementation

## Implementation Notes

### Migration Strategy

The modernization will follow a phased approach to minimize disruption:

**Phase 1: Structure**
- Create new directory structure
- Set up layouts and includes
- Migrate existing content to new structure
- Maintain existing URLs with redirects if needed

**Phase 2: Styling**
- Implement new color scheme
- Update to Bootstrap 5
- Remove jQuery dependencies
- Ensure responsive design

**Phase 3: Blog System**
- Create blog listing page
- Create post layout
- Implement pagination
- Add category and tag pages

**Phase 4: Features**
- Add reading time calculation
- Implement syntax highlighting
- Add post navigation
- Implement canonical URL support

**Phase 5: Optimization**
- Minify assets
- Optimize images
- Implement lazy loading
- Performance testing and tuning

### Color Scheme

The design will use a modern, professional color palette:

**Primary Colors:**
- Primary: `#2563eb` (Blue) - Used for primary actions, links, headers
- Secondary: `#7c3aed` (Purple) - Used for accents, highlights
- Accent: `#f59e0b` (Amber) - Used for call-to-action buttons, important highlights

**Neutral Colors:**
- Text: `#1f2937` (Dark Gray) - Primary text color
- Background: `#ffffff` (White) - Main background
- Light: `#f3f4f6` (Light Gray) - Secondary backgrounds, borders

**Semantic Colors:**
- Success: `#10b981` (Green)
- Warning: `#f59e0b` (Amber)
- Error: `#ef4444` (Red)
- Info: `#3b82f6` (Blue)

All colors meet WCAG AA contrast requirements when used appropriately.

### Local Development Setup

**Prerequisites:**
- Ruby 2.7+ (recommended: 3.0+)
- Bundler gem
- Git

**Setup Steps:**
1. Clone repository
2. Run `bundle install` to install dependencies
3. Run `bundle exec jekyll serve` to start local server
4. Visit `http://localhost:4000` in browser
5. Edit files - site rebuilds automatically

**Development Commands:**
- `bundle exec jekyll serve` - Start development server with live reload
- `bundle exec jekyll build` - Build site to _site directory
- `bundle exec jekyll serve --drafts` - Include draft posts
- `bundle exec jekyll serve --livereload` - Enable live reload (default in newer versions)

### Deployment

**GitHub Pages Deployment:**
1. Push changes to main branch
2. GitHub automatically builds and deploys
3. Site available at username.github.io

**Build Configuration:**
- GitHub Pages uses the github-pages gem
- Build happens automatically on push
- Build logs available in repository settings

### Future Enhancements

Potential future improvements not included in this initial modernization:

- Search functionality (using Lunr.js or Algolia)
- Comments system (using Disqus, Utterances, or similar)
- Dark mode toggle
- Table of contents for long posts
- Related posts suggestions
- Newsletter subscription
- Analytics integration (Google Analytics, Plausible)
- Social sharing buttons
- Print stylesheet
- Progressive Web App (PWA) features
