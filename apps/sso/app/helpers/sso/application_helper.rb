module Sso
  module ApplicationHelper

    def current_user
      Sso::User.find_by_id(session[:user_id])
    end

  end
end
