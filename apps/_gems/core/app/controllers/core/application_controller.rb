module Core
  class ApplicationController < ActionController::Base
    include Pundit

    protect_from_forgery prepend: true

  end
end
