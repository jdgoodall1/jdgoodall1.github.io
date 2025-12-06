# Jon Goodall - Personal Website & Blog

A modern, multi-page Jekyll website featuring a blog, portfolio, and contact information. Built with Jekyll 3.9+, Bootstrap 5, and optimized for GitHub Pages hosting.

## About This Project

This site started as a one-page portfolio forked from [chuckgroom/onepage-bio](https://github.com/chuckgroom/onepage-bio) (see the [original Medium post](https://medium.com/@cgroom/a-software-engineers-one-page-portfolio-4f85ab8a20d1) for context). I've since modernized and expanded it into a full multi-page site with an integrated blog.

**Full disclosure**: I'm a Principal Cloud Engineer, not a web developer. This site was built with the assistance of AI tools (Kiro IDE powered by Claude) to help with the Jekyll/web development aspects while I focused on the infrastructure, DevOps practices, and content. The result is a modern, maintainable site that showcases my work without requiring deep frontend expertise.

## Overview

This site showcases my work as a Principal Cloud Engineer specializing in DevOps and AWS. It includes:

- **Home Page**: Landing page with introduction and highlights
- **About**: Detailed background and experience
- **Blog**: Technical articles on DevOps, AWS, and cloud engineering
- **Contact**: Get in touch via contact form

The site is built with modern web technologies while maintaining compatibility with GitHub Pages free hosting.

## Technology Stack

- **Static Site Generator**: Jekyll 3.9+
- **CSS Framework**: Bootstrap 5.3
- **JavaScript**: Vanilla ES6+ (no jQuery)
- **Syntax Highlighting**: Rouge
- **Hosting**: GitHub Pages
- **Testing**: RSpec with property-based testing (Rantly)

## Prerequisites

Before you begin, ensure you have the following installed:

- **Ruby**: Version 2.7 or higher (3.0+ recommended)
  - Check your version: `ruby --version`
  - Install Ruby: [ruby-lang.org/en/documentation/installation](https://www.ruby-lang.org/en/documentation/installation/)
- **Bundler**: Ruby dependency manager
  - Install: `gem install bundler`
- **Git**: For version control

## Local Development Setup

### 1. Clone the Repository

```bash
git clone https://github.com/jdgoodall1/jdgoodall1.github.io.git
cd jdgoodall1.github.io
```

### 2. Install Dependencies

Install all required gems using Bundler:

```bash
bundle install
```

This will install Jekyll, all plugins, and testing dependencies specified in the Gemfile.

### 3. Generate Category and Tag Pages

Before running the site, generate the category and tag pages from your posts:

```bash
ruby _scripts/generate_taxonomy_pages.rb
```

Or use the Rake task:

```bash
rake generate_taxonomy
```

This automatically creates pages for all categories and tags found in your blog posts. Run this whenever you add new categories or tags.

### 4. Run the Development Server

Start the local Jekyll server with live reload:

```bash
bundle exec jekyll serve
```

Or use the Rake task that automatically generates taxonomy pages first:

```bash
rake serve
```

The site will be available at: **http://localhost:4000**

The server will automatically rebuild the site when you make changes to files. Refresh your browser to see updates.

### 5. View Draft Posts (Optional)

To include draft posts in your local build:

```bash
bundle exec jekyll serve --drafts
```

## Managing Categories and Tags

Category and tag pages are generated automatically from your blog posts. You don't need to manually create HTML files for each category or tag.

### Automatic Generation

Run the generator script whenever you add new categories or tags:

```bash
ruby _scripts/generate_taxonomy_pages.rb
```

Or use the Rake task:

```bash
rake generate_taxonomy
```

The script scans all posts in `_posts/` and creates:
- Category pages in `blog/categories/`
- Tag pages in `blog/tags/`

### Cleaning Generated Pages

To remove all generated taxonomy pages:

```bash
rake clean_taxonomy
```

### Rake Tasks

Available Rake tasks for convenience:

```bash
rake generate_taxonomy  # Generate category and tag pages
rake clean_taxonomy     # Remove generated pages
rake build             # Generate taxonomy + build site
rake serve             # Generate taxonomy + serve site
rake rebuild           # Clean + regenerate + build
```

## Creating Blog Posts

### Basic Post Creation

1. Create a new markdown file in the `_posts` directory
2. Use the naming convention: `YYYY-MM-DD-title-with-hyphens.md`
3. Add front matter at the top of the file
4. Write your content in Markdown

### Example Post

Create a file: `_posts/2024-12-06-my-new-post.md`

```markdown
---
layout: post
title: "My New Blog Post"
date: 2024-12-06
author: Jon Goodall
categories: [DevOps, AWS]
tags: [terraform, automation, cloud]
excerpt: "A brief description of what this post is about"
---

Your blog post content goes here. You can use all standard Markdown features:

## Headings

**Bold text** and *italic text*

- Bullet points
- More bullets

```python
# Code blocks with syntax highlighting
def hello_world():
    print("Hello, World!")
```

![Alt text for image](/img/my-image.png)
```

### Front Matter Options

Required fields:
- `layout`: Always use `post` for blog posts
- `title`: The post title (will appear in listings and on the post page)
- `date`: Publication date in YYYY-MM-DD format

Optional fields:
- `author`: Author name (defaults to site author)
- `categories`: Array of categories, e.g., `[DevOps, AWS]`
- `tags`: Array of tags, e.g., `[terraform, kubernetes, docker]`
- `excerpt`: Short description for post listings (auto-generated if omitted)
- `image`: Featured image path, e.g., `/img/post-image.jpg`
- `canonical_url`: Original URL if cross-posting from another site

### Canonical URLs for Cross-Posted Content

If you're republishing content from another site (like Medium or a company blog), add the canonical URL to give proper SEO credit to the original:

```yaml
---
layout: post
title: "My Cross-Posted Article"
date: 2024-12-06
canonical_url: "https://medium.com/@jdgoodall1/my-article"
---
```

This will:
- Add a canonical link tag in the HTML head
- Display a notice at the top of the post linking to the original
- Include the canonical URL in the RSS feed

### Markdown Features

The site supports all standard Markdown features:

**Text Formatting:**
- `**bold**` → **bold**
- `*italic*` → *italic*
- `~~strikethrough~~` → ~~strikethrough~~

**Links:**
- `[Link text](https://example.com)`

**Images:**
- `![Alt text](/img/image.png)`
- Images automatically get responsive classes and lazy loading

**Code Blocks:**
````markdown
```python
def example():
    return "Syntax highlighted!"
```
````

**Lists:**
- Unordered lists with `-` or `*`
- Ordered lists with `1.`, `2.`, etc.

**Blockquotes:**
```markdown
> This is a blockquote
```

## Project Structure

```
/
├── _config.yml           # Jekyll configuration
├── Gemfile              # Ruby dependencies
├── index.html           # Home page
├── about.html           # About page
├── blog.html            # Blog listing page
├── contact.html         # Contact page
├── _posts/              # Blog post markdown files
│   └── YYYY-MM-DD-title.md
├── _layouts/            # Page templates
│   ├── default.html     # Base layout
│   ├── page.html        # Standard page layout
│   └── post.html        # Blog post layout
├── _includes/           # Reusable components
│   ├── head.html        # HTML head with meta tags
│   ├── navigation.html  # Site navigation
│   ├── footer.html      # Site footer
│   └── post-card.html   # Blog post preview card
├── assets/              # Static assets
│   ├── css/
│   ├── js/
│   └── images/
├── blog/                # Category and tag pages
│   ├── categories/
│   └── tags/
└── spec/                # Test files
```

## Building for Production

To build the site for production (generates static files in `_site/`):

```bash
bundle exec jekyll build
```

The generated site will be in the `_site` directory, ready for deployment.

## Deployment

### GitHub Pages (Automatic)

This site is configured for automatic deployment via GitHub Pages:

1. Push changes to the `main` branch
2. GitHub automatically builds and deploys the site
3. Site is live at: https://jdgoodall1.github.io

Build logs are available in the repository's Actions tab.

### Manual Deployment

If deploying elsewhere, build the site and upload the contents of `_site/` to your web server.

## Testing

### Run All Tests

```bash
bundle exec rspec
```

### Run Specific Test Files

```bash
bundle exec rspec spec/navigation_spec.rb
bundle exec rspec spec/post_spec.rb
```

### HTML Validation

Validate generated HTML (after building):

```bash
bundle exec jekyll build
bundle exec htmlproofer ./_site --disable-external
```

## Configuration

### Site Settings

Edit `_config.yml` to customize:

- Site title, description, and metadata
- Social media links
- Color scheme
- Pagination settings
- Plugin configuration

After changing `_config.yml`, restart the Jekyll server to see changes.

### Color Scheme

The site uses a modern color palette defined in `_config.yml`:

- **Primary**: Blue (#2563eb) - Links, headers, primary actions
- **Secondary**: Purple (#7c3aed) - Accents, highlights
- **Accent**: Amber (#f59e0b) - Call-to-action buttons

All colors meet WCAG AA accessibility standards for contrast.

## Troubleshooting

### Jekyll Won't Start

**Problem**: `bundle exec jekyll serve` fails

**Solutions**:
- Ensure Ruby 2.7+ is installed: `ruby --version`
- Reinstall dependencies: `bundle install`
- Clear the cache: `bundle exec jekyll clean`
- Check for syntax errors in `_config.yml`

### Port Already in Use

**Problem**: Port 4000 is already in use

**Solution**: Use a different port:
```bash
bundle exec jekyll serve --port 4001
```

### Changes Not Appearing

**Problem**: File changes don't show up in the browser

**Solutions**:
- Hard refresh the browser (Ctrl+Shift+R or Cmd+Shift+R)
- Restart the Jekyll server
- Clear the `_site` directory: `bundle exec jekyll clean`
- Check that the file isn't in the `exclude` list in `_config.yml`

### Build Errors

**Problem**: Site fails to build

**Common causes**:
- Invalid YAML in front matter (check for proper indentation)
- Missing required front matter fields (title, date, layout)
- Invalid Liquid syntax in templates
- Malformed markdown

**Solution**: Check the error message for the specific file and line number.

### Ruby Version Issues

**Problem**: Bundler complains about Ruby version

**Solution**: Install the required Ruby version using a version manager:

**Using rbenv**:
```bash
rbenv install 3.0.0
rbenv local 3.0.0
```

**Using RVM**:
```bash
rvm install 3.0.0
rvm use 3.0.0
```

### Missing Gems

**Problem**: `LoadError` or missing gem errors

**Solution**: Reinstall dependencies:
```bash
bundle clean --force
bundle install
```

### Webrick Error (Ruby 3.0+)

**Problem**: `cannot load such file -- webrick`

**Solution**: Already included in Gemfile, but if needed:
```bash
bundle add webrick
```

### GitHub Pages Build Failure

**Problem**: Site builds locally but fails on GitHub Pages

**Solutions**:
- Ensure all plugins are GitHub Pages compatible (check `_config.yml`)
- Verify the `github-pages` gem is in your Gemfile
- Check GitHub Actions logs for specific errors
- Test locally with: `bundle exec github-pages build`

### Pagination Not Working

**Problem**: Blog pagination doesn't appear

**Solutions**:
- Ensure you have more posts than the `paginate` value in `_config.yml`
- Check that `jekyll-paginate` is in the plugins list
- Verify `blog.html` uses the paginator correctly
- Restart Jekyll server after config changes

### Category or Tag Pages 404

**Problem**: Clicking on a category or tag link returns 404

**Solution**: Generate the taxonomy pages:
```bash
ruby _scripts/generate_taxonomy_pages.rb
```

Or use the Rake task:
```bash
rake generate_taxonomy
```

Run this whenever you add new categories or tags to your posts.

### New Categories/Tags Not Showing

**Problem**: Added new categories or tags but they don't appear

**Solution**: Regenerate taxonomy pages:
```bash
rake generate_taxonomy
bundle exec jekyll serve
```

## Resources

- [Jekyll Documentation](https://jekyllrb.com/docs/)
- [GitHub Pages Documentation](https://docs.github.com/en/pages)
- [Markdown Guide](https://www.markdownguide.org/)
- [Bootstrap 5 Documentation](https://getbootstrap.com/docs/5.3/)
- [Liquid Template Language](https://shopify.github.io/liquid/)

## Credits & License

This project started from the [onepage-bio](https://github.com/chuckgroom/onepage-bio) template by Chuck Groom and has been significantly modernized and expanded with:

- Multi-page architecture
- Integrated blog system with categories and tags
- Modern Bootstrap 5 styling
- Automated taxonomy generation
- Property-based testing
- SEO optimization

Built with assistance from AI tools (Kiro IDE powered by Claude) for web development aspects.

See [LICENCE](LICENCE) for details.

## Contact

- **Email**: jongoodall14@gmail.com
- **LinkedIn**: [jdgoodall1](https://www.linkedin.com/in/jdgoodall1/)
- **GitHub**: [jdgoodall1](https://github.com/jdgoodall1)
- **Medium**: [@jdgoodall1](https://medium.com/@jdgoodall1)
