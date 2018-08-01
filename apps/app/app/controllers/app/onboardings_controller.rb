module App
  class OnboardingsController < AuthenticatedController

    layout 'onboarding'

    skip_before_action :ensure_onboarding_complete!

    def new
      @onboarding = App::UserOnboarding.new
    end

    def create
    end

  end
end