task :simulate_heavy_user => :environment do

  u = User.find_by_email('ian.purton@gmail.com')
  
  while u.balance > 0 do
    
    r = rand * 100.0
    b = u.bets.new
    b.secret = Secret.last
    b.server_seed = SecureRandom.hex(12)
    b.amount = 10000
    b.game = 49.5
    b.client_seed = 'baebbde11f8bb328'
    b.save
    
    sleep 4
  end
end

task :simulate_gamblers_ruin, [:email] => :environment do |t, args|
  
  user_email = args[:email]

  u = User.find_by_email(user_email)
  
  LIMIT = 20000000
  GAMBLE = 10000
  
  profit = 0
  
  while u.balance > GAMBLE do
    
    win = false
    amount = GAMBLE
    
    while win == false and amount < u.balance and amount < LIMIT
      b = u.bets.new
      b.secret = Secret.last
      b.server_seed = SecureRandom.hex(12)
      b.amount = amount
      b.game = 49.5
      b.client_seed = 'baebbde11f8bb328'
      b.save
      
      Pusher['test_channel'].trigger('my_event', b.as_json)
      
      win = b.win?
      
      if !win
        amount = amount * 2
      else 
        # We won, start again.
        puts "A win resetting amount, total we had to bet " + amount.to_s + " profit " + profit.to_s
        profit = profit + GAMBLE
        amount = GAMBLE
        Bet.where("client_seed = ? and created_at < ?", "baebbde11f8bb328", 3.minutes.ago).delete_all
      end
      sleep (rand 120)
    end
    
  end

  Bet.where("client_seed = ?", "baebbde11f8bb328").delete_all
  u.balances.where("amount < 100000000").delete_all
end