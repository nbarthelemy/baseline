module Api::V1
  class UsersController < ApiController

    swagger_controller :users, 'Users'

    swagger_api :index do
      summary 'Returns all users'
      notes 'Notes...'
    end

	  # GET /v1/users
	  def index
	    render json: Api::User.all
	  end

  end
end