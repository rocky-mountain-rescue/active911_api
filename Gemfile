# frozen_string_literal: true

ruby File.read(".ruby-version").strip

source "https://rubygems.org"

gemspec

group :code_quality do
  gem "git-lint", "~> 5.0"
  gem "reek", "~> 6.1"
  gem "simplecov", "~> 0.22", require: false
end

group :development do
  gem "rake", "~> 13.0"
  gem "tocer", "~> 15.0"
end

group :test do
  gem "guard-rspec", "~> 4.7", require: false
  gem "rspec", "~> 3.12"
  gem "webmock", "~> 3.18.1"
end

group :tools do
  gem "amazing_print", "~> 1.4"
  gem "bundler-audit"
  gem "debug", "~> 1.7"
end

gem "rubocop"
gem "rubocop-performance"
gem "rubocop-rspec"
gem "rubocop-rake"
gem "rubocop-shopify"
