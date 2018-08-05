module Api
	module TokenThrottleable
		extend ActiveSupport::Concern

		included do
      before_action :throttle_token
		end

    def throttle_ip
      client_ip = request.env["REMOTE_ADDR"]
      key = "api:count:#{client_ip}"
      count = Api::REDIS.get(key)

      unless count
        Api::REDIS.set(key, 0)
        Api::REDIS.expire(key, Api::THROTTLE_TIME_WINDOW)
        return true
      end

      if count.to_i >= Api::THROTTLE_MAX_REQUESTS
        render json: {
          message: "You have fired too many requests. Please wait for some time."
        }, status: 429
        return
      end
      Api::REDIS.incr(key)
      true
    end

    def throttle_token
      if @token.present?
        key = "api:count:#{@token}"
        count = Api::REDIS.get(key)

        unless count
          Api::REDIS.set(key, 0)
          Api::REDIS.expire(key, Api::THROTTLE_TIME_WINDOW)
          return true
        end

        if count.to_i >= Api::THROTTLE_MAX_REQUESTS
          render :json => {:message => "You have fired too many requests. Please wait for some time."}, :status => 429
          return
        end
        Api::REDIS.incr(key)
        true
      else
        false
      end
    end

	end
end
