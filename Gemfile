source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '~> 5.1.2'
gem 'puma', '~> 3.7'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.2'
gem 'turbolinks', '~> 5'
gem 'listen'
gem 'sqlite3'
gem 'factory_girl_rails'

group :development, :test do
  gem 'pry-byebug'
  gem 'pry-rails'
  gem 'capybara', '~> 2.13'
end

group :test do
  gem 'rspec', require: false
  gem 'rspec-rails'
  gem 'rspec-retry'
  gem 'shoulda-matchers'
end
