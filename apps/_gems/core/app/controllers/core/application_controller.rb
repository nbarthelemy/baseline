module Core
  class ApplicationController < ActionController::Base
    include Pundit

    protect_from_forgery prepend: true

    before_action :permit_html_flashes, if: proc { flash[:html_safe] == true }

  private

    def permit_html_flashes
      flash.keys.reject{|k| k == :html_safe }.each do |k|
        flash.now[k] = flash[k].to_s.html_safe
      end
    end

  end
end
