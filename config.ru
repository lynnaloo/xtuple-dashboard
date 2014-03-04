require 'dashing'
require 'dotenv'

if ENV['DOTENV_FILE']
  Dotenv.load ENV['DOTENV_FILE']
else
  Dotenv.load
end

ENV['TWITTER_CONSUMER_KEY']
ENV['TWITTER_CONSUMER_SECRET']
ENV['TWITTER_ACCESS_TOKEN']
ENV['TWITTER_ACCESS_TOKEN_SECRET']

configure do
  set :auth_token, 'YOUR_AUTH_TOKEN'

  helpers do
    def protected!
     # Put any authentication code you want in here.
     # This method is run before accessing any resource.


    end
  end
end

map Sinatra::Application.assets_prefix do
  run Sinatra::Application.sprockets
end

run Sinatra::Application
