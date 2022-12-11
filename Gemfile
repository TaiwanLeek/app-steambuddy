# frozen_string_literal: true

source 'https://rubygems.org'
ruby File.read('.ruby-version').strip

## Configuration and Utilities
gem 'figaro', '~> 1.2'
gem 'rake', '~> 13.0'

## Web Application
gem 'multi_json', '~> 1.15'
gem 'puma', '~> 6'
gem 'rack-session', '~> 0.3'
gem 'roar', '~> 1.1'
gem 'roda', '~> 3'
gem 'slim', '~> 4'

# Controllers and services
gem 'dry-monads', '~> 1.4'
gem 'dry-transaction', '~> 0.13'
gem 'dry-validation', '~> 1.7'

# Validation
gem 'dry-struct', '~> 1'
gem 'dry-types', '~> 1'

## TESTING
group :test do
  gem 'minitest', '~> 5'
  gem 'minitest-rg', '~> 5'
  gem 'page-object', '~> 2.3'
  gem 'simplecov', '~> 0'
  gem 'vcr', '~> 6'
  gem 'webmock', '~> 3'
end

group :development do
  gem 'rerun', '~> 0'
end

# DEBUGGING
gem 'pry'

## QUALITY
group :development do
  gem 'flog'
  gem 'reek'
  gem 'rubocop', '~> 1.40'
end

## Database
group :production do
  gem 'pg'
end

gem 'http', '~> 5.1'
