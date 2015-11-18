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
    config.redis = {
      url: ENV['REDISCLOUD_URL'],
      size: 1
    }
  end

  # NOTE: The configuration hash must have symbolized keys.
  Sidekiq.configure_server do |config|
    config.redis = {
      url: ENV['REDISCLOUD_URL'],
      size: 5
    }
  end
end
