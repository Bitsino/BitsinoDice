task :pirate_metrics => :environment do

  count = User.where("created_at >= ?", 1.day.ago).count
  bets = Bet.where("created_at >= ?", 1.day.ago).count
  btc = 0
  
  message = "User Registrations (last 24 hours) : <em>#{count}</em> "
  message += "<br>"
  message += "Bets made (last 24 hours)  : <em>#{bets}</em> "
  message += "<br>"
  message += "BTC Deposited (last 24 hours)  : <em>#{btc}</em> "
  
  uri = URI.parse("https://hall.com")
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true
  http.verify_mode = OpenSSL::SSL::VERIFY_NONE
  request = Net::HTTP::Post.new("/api/1/services/generic/550e2fabd234eda198cd0936e8799e63")
  request.add_field('Content-Type', 'application/json')
  request.body = {'title' => 'How are we doing ?', 'message' => message}.to_json
  response = http.request(request)
end