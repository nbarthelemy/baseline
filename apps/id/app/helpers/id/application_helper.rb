module Id
  module ApplicationHelper

    def current_user
      Id::User.find_by_id(session[:user_id])
    end

  end
end
