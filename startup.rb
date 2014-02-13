pid1 = Process.spawn('rackup faye.ru -E production -s thin')
puts "Faye running, PID : #{pid1}"
pid2 = Process.spawn('bundle exec sidekiq --config ./config/sidekiq.yml')
puts "Sidekiq running, PID : #{pid2}"