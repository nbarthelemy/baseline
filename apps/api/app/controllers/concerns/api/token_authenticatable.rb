module Api
	module TokenAuthenticatable
		extend ActiveSupport::Concern

    included do
      before_action :authenticate
    end

  protected

    def authenticate
      authenticate_token || render_unauthorized
    end

    def authenticate_token
      authenticate_with_http_token do |token, options|
        @current_user = User.find_by(api_key: token)
        @token = token
      end
    end

    def render_unauthorized(realm = "Application")
      self.headers["WWW-Authenticate"] = %(Token realm="#{realm.gsub(/"/, "")}")
      render json: { message: 'Bad credentials' }, status: :unauthorized
    end

	end
end