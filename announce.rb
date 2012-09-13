require 'sinatra'
require 'open-uri'
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

post '/hooker' do
  push = JSON.parse(params[:payload])

  if push 
    (push["commits"] || []).each do |commit_meta|

      uri_string = "https://api.github.com/repos/clayallsopp/rubymotion-wrappers/commits/#{commit_meta['id']}"
      puts "going for #{uri_string} ..."      
      response = open(uri_string) {|io| io.read}
      commit = JSON.parse(response)

      commit["files"].find_all { |f| f['filename'] == 'data.json' }.each do |change|

        patch = change['patch']
        possible_jsons = patch.split("\n").map { |d| if d[0] == "+"; d[1..-1]; else; d; end }.join('').scan(/(\{.*?\})+/)

        possible_jsons.each do |broke|

          begin 
            perhaps = JSON.parse(broke.first)

            if perhaps.has_key?("name") && perhaps.has_key?("url")
              tags = perhaps['tags'] || []
              tags_string = tags.map {|t| "\##{t}"}.join(" ")
              tweet_string = "New wrapper - #{perhaps['name']} #{perhaps['url']} http://rubymotion-wrappers.com #rubymotion #{tags_string}"[0...140]
              client.update(tweet_string)
            end
          rescue
            # do nothing
          end

        end
      end
    end
  end
end
