require 'rack/redis_throttle'

module Api
  class DailyRateLimit < Rack::RedisThrottle::Daily

    def call(env)
      @user_rate_limit = user_rate_limit(env)
      super
    end

    def client_identifier(request)
      @user_rate_limit.respond_to?(:_id) ? @user_rate_limit._id : 'user-unknown'
    end

    def max_per_window(request)
      @user_rate_limit.respond_to?(:rate_limit) ? @user_rate_limit.rate_limit : 1000
    end

    # Rate limit only requests sending the access token
    def need_protection?(request)
      request.env.has_key?('HTTP_AUTHORIZATION')
    end

    private

    def user_rate_limit(env)
      request      = Rack::Request.new(env)
      token        = request.env['HTTP_AUTHORIZATION'].split(' ')[-1]
      access_token = Doorkeeper::AccessToken.where(token: token).first
      access_token ? Api::User.find(access_token.resource_owner_id) : nil
    end
  end
end