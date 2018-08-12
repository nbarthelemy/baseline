module Api::V1
  class CredentialsController < ApiController

    def me
      respond_with current_resource_owner
    end

  end
end