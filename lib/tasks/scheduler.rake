desc "Generate new secret each day"
task :generate_secret => :environment do
  Secret.create
end

desc "Sweep addresses on block chain"
task :sweep_blockchain => :environment do
  User.sweep_for_incoming_coins
end

desc "Create payouts"
task :create_payouts => :environment do
  Cashout.create_onchain_payment_request
end

desc "Sweep incoming coins to fund"
task :sweep_tx => :environment do
  User.sweep_bitcoins_to_onchain_fund
end