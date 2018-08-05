# For each application load all of it's dependencies helpers
Rails.application.config.after_initialize do
  BootInquirer.enabled(:apps).each do |app|
    app.dependencies.each do |dep|
      # begin
        "#{app.namespace}::ApplicationController".constantize.class_eval do
          helper BootInquirer.engine(dep).engine.helpers
        end
      # rescue NameError => e
      #   Rails.logger.warn e.message
      # end
    end
  end
end

