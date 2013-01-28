source 'http://rubygems.org'
gemspec

group :test do
  if RUBY_PLATFORM.downcase.include? "darwin"
    gem 'guard-rspec'
    gem 'rb-fsevent'
    gem 'growl'
  end
  gem 'debugger'
end

gem 'spree_advanced_reporting', :git => 'https://github.com/greinacker/spree_advanced_reporting.git'

