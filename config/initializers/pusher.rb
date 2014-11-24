require 'pusher'

if ENV['PUSHER_URL'] != nil
  Pusher.url = ENV['PUSHER_URL']
elsif ENV['pusher_url'] != nil
  Pusher.url = ENV['pusher_url']
end