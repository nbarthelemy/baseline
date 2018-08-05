require "core"
require "ui"
#require "sso/client"

module Admin
  class Engine < ::Rails::Engine
    isolate_namespace Admin
  end
end
