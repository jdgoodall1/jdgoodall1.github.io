---
inclusion: auto
---

# Local Development

This is a Jekyll site deployed via GitHub Pages. The `github-pages` gem pins Jekyll to 3.10.0.

## Running Locally

Run `./serve.sh` from the project root. It handles Ruby version management, gem installation, and starts the dev server with live reload at http://localhost:4000.

If you need to do it manually:

```bash
rbenv local 3.3.11
eval "$(rbenv init -)"
bundle install
bundle exec jekyll serve --livereload
```

## Ruby Version

- Requires Ruby 3.3.x (managed via rbenv)
- The `.ruby-version` file controls which version is active in this directory
- Do NOT use system Ruby or Ruby 4.x — the `github-pages` gem is incompatible

## Building Without Serving

```bash
bundle exec jekyll build
```

Output goes to `_site/`.

## Key Constraints

- Cannot upgrade past Jekyll 3.10.0 without switching away from GitHub Pages built-in build
- All plugins must be on the GitHub Pages whitelist: https://pages.github.com/versions/
- The Gemfile.lock needs the `arm64-darwin` platform for macOS — if missing, run `bundle lock --add-platform arm64-darwin`

## Collections

- **Posts**: `_posts/` — blog posts, permalink `/blog/:year/:month/:day/:title/`
- **Talks**: `_talks/` — speaking engagements, permalink `/speaking/:slug/`

## Adding a New Talk

1. Create `_talks/your-talk-slug.md` with front matter:

```yaml
---
layout: talk
title: "Talk Title"
slug: your-talk-slug
date: 2026-01-15
event: "Event Name"
location: "City, Country"
video_url: "https://www.youtube.com/watch?v=VIDEO_ID"
description: "Brief description for the card on /speaking/"
---

Full talk description / notes go here as markdown content.
```

2. The talk will automatically appear on `/speaking/` and have its own page at `/speaking/your-talk-slug/`.

3. Also update `_data/speaking.yml` to keep it in sync (used as a data reference).
