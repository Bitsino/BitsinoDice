require 'pusher'

if ENV['PUSHER_URL'] != nil
  Pusher.url = ENV['PUSHER_URL']
else
  Pusher.url = ENV['pusher_url']
end
Pusher.logger = Rails.logger