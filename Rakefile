require 'fileutils'

desc "Generate category and tag pages from posts"
task :generate_taxonomy do
  ruby '_scripts/generate_taxonomy_pages.rb'
end

desc "Clean generated taxonomy pages"
task :clean_taxonomy do
  FileUtils.rm_rf('blog/categories')
  FileUtils.rm_rf('blog/tags')
  puts "Cleaned taxonomy pages"
end

desc "Build the Jekyll site"
task :build => :generate_taxonomy do
  sh "bundle exec jekyll build"
end

desc "Serve the Jekyll site locally"
task :serve => :generate_taxonomy do
  sh "bundle exec jekyll serve --livereload"
end

desc "Clean and rebuild everything"
task :rebuild => [:clean_taxonomy, :generate_taxonomy] do
  sh "bundle exec jekyll clean"
  sh "bundle exec jekyll build"
end

task :default => :serve
