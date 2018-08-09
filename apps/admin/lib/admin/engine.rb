require "core"
require "ui"
require "identity"

module Admin
  class Engine < ::Rails::Engine
    isolate_namespace Admin
  end
end
