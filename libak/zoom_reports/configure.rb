require 'zoom'

Zoom.configure do |c|
  c.api_key = ENV['API_KEY']
  c.api_secret = ENV['API_SECRET']
end
