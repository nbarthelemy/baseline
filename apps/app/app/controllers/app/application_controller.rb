module App
  class ApplicationController < ActionController::Base

    protect_from_forgery prepend: true

  end
end