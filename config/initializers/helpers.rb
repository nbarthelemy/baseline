# For each application load all of it's dependencies helpers
BootInquirer.enabled(:apps).each do |app|
  app.dependencies.each do |dep|
    "#{app.namespace}::ApplicationController".constantize.
      helper BootInquirer.engine(dep).engine.helpers
  end
end