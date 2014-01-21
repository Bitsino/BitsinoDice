desc "Generate new secret each day"
task :generate_secret => :environment do
  Secret.create
end