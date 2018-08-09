module Id::Api::V1
  class CredentialsController < ApiController

    before_action :doorkeeper_authorize!

    def me
      respond_with current_resource_owner
    end

  end
end