#!/bin/bash
set -e

REQUIRED_RUBY="3.3"

echo "=== Jekyll Local Setup ==="

# Check rbenv is available
if ! command -v rbenv &> /dev/null; then
  echo "❌ rbenv not found. Install it first: brew install rbenv"
  exit 1
fi

# Check for a compatible Ruby version (3.3.x)
RUBY_VERSION=$(rbenv versions --bare | grep "^${REQUIRED_RUBY}" | tail -1)

if [ -z "$RUBY_VERSION" ]; then
  echo "No Ruby ${REQUIRED_RUBY}.x found. Installing latest ${REQUIRED_RUBY}..."
  LATEST=$(rbenv install --list 2>/dev/null | grep "^${REQUIRED_RUBY}" | tail -1 | tr -d ' ')
  rbenv install "$LATEST"
  RUBY_VERSION="$LATEST"
fi

echo "Using Ruby $RUBY_VERSION"
rbenv local "$RUBY_VERSION"
eval "$(rbenv init -)"

# Install bundler if missing
if ! rbenv exec gem list bundler -i &> /dev/null; then
  echo "Installing bundler..."
  rbenv exec gem install bundler
fi

# Install gems
echo "Installing gems..."
rbenv exec bundle install

# Serve
echo ""
echo "🚀 Starting Jekyll at http://localhost:4000"
echo "   Press Ctrl+C to stop"
echo ""
rbenv exec bundle exec jekyll serve --livereload
