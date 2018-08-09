module Id::Api::V1
  class ApiController < ::Id::ApplicationController

    respond_to :json

  protected

    def current_resource_owner
      User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
    end

  end
end
