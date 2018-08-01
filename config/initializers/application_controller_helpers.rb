Rails.application.config.after_initialize do
  ActionController::Base.class_eval do
    BootInquirer.enabled(:engines).each do |engine|
      helper engine.engine.helpers
    end
  end
end

