module Api
  class ApplicationController < Core::ApiController
    include Api::SwaggerDocs

    before_action :doorkeeper_authorize!

  protected

    def current_resource_owner
      @current_resource_owner ||= if doorkeeper_token
        Api::User.find(doorkeeper_token.resource_owner_id)
      end
    end
    alias :current_user :current_resource_owner

  end
end