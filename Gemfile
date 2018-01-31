source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end



gem 'rails', '~> 5.1.4'
gem 'puma', '~> 3.7'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.2'
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.5'
gem 'jquery-rails'
gem 'bootstrap-sass', '~> 3.3', '>= 3.3.7'
gem 'stock_quote', '~> 1.5', '>= 1.5.4'
gem 'devise', '~> 4.3'
gem 'rest-client', '~> 2.0', '>= 2.0.2'
gem 'omniauth-facebook'
gem 'dotenv-rails', :github => "bkeepers/dotenv"


group :development, :test do

  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'capybara', '~> 2.13'
  gem 'selenium-webdriver'
  gem 'rspec-rails', '~> 3.7', '>= 3.7.2'
  gem 'poltergeist', '~> 1.17'
  gem 'simplecov', '~> 0.15.1'



end

group :development do

  gem 'sqlite3'
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'

end


group :production do

  gem 'pg', '~> 0.21.0'
  gem 'rails_12factor', '~> 0.0.3'

end




# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
