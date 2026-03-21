source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.3.6'

gem 'rails', '~> 7.1'
gem 'sqlite3', '~> 1.6'
gem 'puma', '~> 6.0'
gem 'sass-rails', '~> 6.0'
gem 'turbo-rails'
gem 'stimulus-rails'
gem 'jbuilder'
gem 'bootsnap', '>= 1.4.4', require: false

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  gem 'web-console', '>= 4.1.0'
  gem 'error_highlight', '>= 0.4.0', platforms: [:ruby]
end

group :test do
  gem 'capybara', '>= 3.26'
  gem 'selenium-webdriver'
end
