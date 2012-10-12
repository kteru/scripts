#!/usr/bin/ruby -Ku
require 'rubygems'
require 'oauth'

# path
dir = File.dirname(File.expand_path(__FILE__))

# application
CONSUMER_KEY = 'hogehogehogehogehogeh'
CONSUMER_SECRET = 'homuhomuhomuhomuhomuhomuhomuhomuhomuhomuh'
TOKEN_FILE = File.join(dir, 'gettwittertoken.token')

if !File.exist?(TOKEN_FILE)
  # get token
  consumer = OAuth::Consumer.new(CONSUMER_KEY, CONSUMER_SECRET, :site => 'http://twitter.com')
  request_token = consumer.get_request_token

  # print url
  puts 'Access the following URL.'
  puts request_token.authorize_url

  # input numbers
  print('Enter the displayed numbers. > ')
  access_token = request_token.get_access_token({:oauth_verifier => gets().chomp()})

  # save to the file
  f = open(TOKEN_FILE, 'w')
  f.print(
          access_token.token << "\n" <<
          access_token.secret << "\n"
          )
  f.close
else
  # print message
  puts TOKEN_FILE + ' is already exist.'
end

