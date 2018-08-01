module App
  class AuthenticatedController < App::ApplicationController

    before_action :authenticate_user!
    before_action :ensure_onboarding_complete!

  protected

    def ensure_onboarding_complete!
      unless current_user.onboarding_complete?
        redirect_to new_onboarding_path
      end
    end

  end
end