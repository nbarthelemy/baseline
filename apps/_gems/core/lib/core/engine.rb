require 'devise'

module Core
  class Engine < ::Rails::Engine
    isolate_namespace Core

    initializer :prepend_migrations do |app|
      unless app.root.to_s.match root.to_s
        config.paths['db/migrate'].expanded.each do |expanded_path|
          app.config.paths['db/migrate'].unshift expanded_path
        end
      end
    end

    initializer :prepend_seeds do |app|
      unless app.root.to_s.match root.to_s
        config.paths['db/seeds.rb'].expanded.each do |expanded_path|
          app.config.paths['db/seeds.rb'].unshift expanded_path
        end
      end
    end

  end
end
