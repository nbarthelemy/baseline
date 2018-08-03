# MONKEY PATCH!!!
# https://github.com/rails/rails/pull/33118
#
# Fixes:
# * Development mode deadlocks
# * ArgumentError: unknown firstpos: NilClass
#
# Allows use of "config.eager_load = true"

module ActionDispatch
  module Journey
    class Routes
      def ast
        @ast ||= begin
          asts = anchored_routes.map(&:ast)
          Nodes::Or.new(asts) unless asts.empty?
        end
      end
    end
  end
end