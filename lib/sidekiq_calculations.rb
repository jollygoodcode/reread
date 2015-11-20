class SidekiqCalculations
  def web_dynos
    Integer(ENV.fetch('NUMBER_OF_WEB_DYNOS'))
  end

  def worker_dynos
    Integer(ENV.fetch('NUMBER_OF_WORKER_DYNOS'))
  end

  def max_redis_connection
    Integer(ENV.fetch('MAX_REDIS_CONNECTION'))
  end

  # Copied from `config/puma.rb`.
  # If default changes, then this needs to be updated
  def puma_workers
    Integer(ENV.fetch("WEB_CONCURRENCY", 2))
  end

  # Copied from `config/puma.rb`.
  # If default changes, then this needs to be updated
  def puma_threads
    Integer(ENV.fetch("WEB_MAX_THREADS", 5))
  end

  def raise_error_for_env!
    max_redis_connection
    web_dynos
    worker_dynos
  rescue KeyError, TypeError # Integer(nil) raises TypeError
    raise <<-ERROR
Sidekiq Server Configuration failed.
!!!======> Please add ENV:
  - MAX_REDIS_CONNECTION
  - NUMBER_OF_WEB_DYNOS
  - NUMBER_OF_WORKER_DYNOS
    ERROR
  end

  def client_redis_size
    puma_workers * (puma_threads/2) * web_dynos
  end

  def server_concurrency_size
    (max_redis_connection - client_redis_size - sidekiq_reserved) / paranoid_divisor
  end

  private

    def sidekiq_reserved
      2
    end

    # This is added to bring down the value of Concurrency
    # so that there's leeway to grow
    def paranoid_divisor
      2
    end
end
