require 'sidekiq_calculations'

if defined?(Sidekiq)
  Sidekiq::Worker::ClassMethods.class_eval do
    def perform_async_with_retry(*args)
      perform_async_count = 0
      begin
        perform_async_without_retry(*args)
      rescue Redis::CannotConnectError
        if (perform_async_count+=1) <= 3
          sleep 1
          retry
        else
          raise
        end
      end
    end
    alias_method :perform_async_without_retry, :perform_async
    alias_method :perform_async, :perform_async_with_retry
  end

  # NOTE: The configuration hash must have symbolized keys.
  Sidekiq.configure_client do |config|
    sidekiq_calculations = SidekiqCalculations.new
    sidekiq_calculations.raise_error_for_env!

    config.redis = {
      url: ENV['REDISCLOUD_URL'],
      size: sidekiq_calculations.client_redis_size
    }
  end

  # NOTE: The configuration hash must have symbolized keys.
  Sidekiq.configure_server do |config|
    sidekiq_calculations = SidekiqCalculations.new
    sidekiq_calculations.raise_error_for_env!

    config.options[:concurrency] = sidekiq_calculations.server_concurrency_size
    config.redis = {
      url: ENV['REDISCLOUD_URL']
    }
  end
end
