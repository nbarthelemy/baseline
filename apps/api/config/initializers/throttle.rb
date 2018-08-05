require "redis"

redis_conf  = YAML.load(File.join(Rails.root, 'config', 'redis.yml'))
Api::REDIS = Redis.new(host: redis_conf['host'], port: redis_conf['port'])

# # We will allow a client a maximum of 60 requests in 15 minutes. The following constants need to be defined in throttle.rb
Api::THROTTLE_TIME_WINDOW = 15 * 60
Api::THROTTLE_MAX_REQUESTS = 60