require "core"
require "ui"

module Admin
  class Engine < ::Rails::Engine
    isolate_namespace Admin
  end
end
