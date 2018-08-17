require 'rack'

module Rack
  module RedisThrottle
    class Connection

      def self.create(options={})
        url = redis_provider || 'redis://localhost:6379/0'
        options.reverse_merge!({ url: url })
        uri = URI.parse(options[:url])
        client = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password, driver: :hiredis)
        Redis::Namespace.new("redis-throttle:#{ENV['RACK_ENV']}:rate", redis: client)
      end

      private

      def self.redis_provider
        ENV['REDIS_RATE_LIMIT_URL']
      end
    end
  end
end
