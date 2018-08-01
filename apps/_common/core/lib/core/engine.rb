module Core
  class Engine < ::Rails::Engine
    isolate_namespace Core

    # initializer :eager_load_all_core_models do
    #   paths["app/models"].existent.each do |path|
    #     Dir["#{path}/**/*.rb"].each do |f|
    #       require f
    #     end
    #   end
    # end

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
