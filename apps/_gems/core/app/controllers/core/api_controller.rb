module Core
  class ApiController < ActionController::API
    include Pundit

    respond_to :json

  end
end