#require 'sinatra'
require 'twitter_oauth'

client = TwitterOAuth::Client.new(
  :consumer_key    => ENV['TWITTER_CONSUMER_KEY'],
  :consumer_secret => ENV['TWITTER_CONSUMER_SECRET'],
  :token           => ENV['TWITTER_ACCESS_TOKEN'],
  :secret          => ENV['TWITTER_ACCESS_SECRET']
)

get '/' do
  "Hi there! I announce new new new Rubymotion Wrappers. Follow me at <a href='https://twitter.com/RM_Wrappers'>@RM_Wrappers</a>"
end