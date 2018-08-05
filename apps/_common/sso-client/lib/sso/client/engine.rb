module Sso
  module Client
    class Engine < ::Rails::Engine
      isolate_namespace Sso::Client
    end
  end
end
