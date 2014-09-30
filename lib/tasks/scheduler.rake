desc "Generate new secret each day"
task :generate_secret => :environment do
  Secret.create
end

desc "Sweep addresses on block chain"
task :sweep_blockchain => :environment do
  User.sweep_for_incoming_coins
end