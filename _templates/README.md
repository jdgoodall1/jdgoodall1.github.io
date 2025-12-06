# Post Templates

This directory contains template files for creating new blog posts. These files are excluded from Jekyll processing and serve as reference templates.

## Available Templates

### post-template.md

A comprehensive blog post template with:
- Complete front matter structure
- All available metadata fields (including optional ones)
- Examples of common Markdown formatting
- Code blocks with syntax highlighting
- Lists, tables, blockquotes, and more

## Usage

When creating a new blog post:

1. Copy `post-template.md` to the `_posts` directory
2. Rename it following Jekyll's naming convention: `YYYY-MM-DD-title-of-post.md`
3. Update the front matter with your post details
4. Write your content
5. Remove any sections you don't need

## Front Matter Fields

### Required Fields
- `layout`: Always use `post` for blog posts
- `title`: The post title (will be the h1)
- `date`: Publication date and time
- `author`: Your name
- `categories`: Array of categories (e.g., `[DevOps, AWS]`)
- `tags`: Array of tags (e.g., `[terraform, automation]`)
- `excerpt`: Brief summary for listings and SEO

### Optional Fields
- `canonical_url`: Use when cross-posting from another site (for SEO)
- `image`: Featured image for the post

## Naming Convention

Blog post files must follow this format:
```
YYYY-MM-DD-title-with-hyphens.md
```

Examples:
- `2024-12-06-getting-started-with-terraform.md`
- `2024-12-15-aws-lambda-best-practices.md`

## Markdown Tips

- Use `##` for main sections (h2) - the post title is already h1
- Use `###` for subsections (h3)
- Never use `#` (h1) in post content - it creates multiple h1 tags
- Add alt text to all images for accessibility
- Use code fences with language identifiers for syntax highlighting

## Categories and Tags

Keep categories broad and tags specific:

**Categories** (2-3 max):
- DevOps
- AWS
- Web Development
- Programming
- Testing

**Tags** (3-5 recommended):
- terraform
- docker
- kubernetes
- ci-cd
- automation
- python
- javascript
