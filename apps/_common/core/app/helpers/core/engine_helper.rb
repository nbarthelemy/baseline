module Core
	module EngineHelper

		def current_engine
      namespace = controller_path.split('/').first
      engine_name = "#{namespace}_app".to_sym
      respond_to?(engine_name) ? public_send(engine_name) : main_app
		end

	end
end