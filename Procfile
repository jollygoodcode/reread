web: bundle exec puma -C config/puma.rb -p $PORT
worker: bundle exec sidekiq -e $RAILS_ENV -q default -q mailers -c 5
