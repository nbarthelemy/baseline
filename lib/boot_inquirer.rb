# This determines which engines to boot / mount within the operator app (v3).
# The boot flag is a collection of characters representing the different engines in this project
# For example:
#   ~> ENGINE_BOOT=api bundle exec rails c
#   => will boot the api engines - but none of the others
#
# The boot flag can be negated to have the opposite effect.
# For example:
#   ~> ENGINE_BOOT=-api bundle exec rails c
#   => will boot all engines except api
#
# The boot flag characters are not necessarily the first letter of each engine name, so check this file if you're using boot flags.
#
# When Rails.env is "test" all boot flags are assumed to be present, no matter what you provide.

class BootInquirer

  DEPENDENCY_REGEXP = /dependency\s+(?:'|")(.+?)(?:'|")/i

  class << self

    def apps
      @@apps ||= load_and_initialize_gems('../apps', BootInquirer::App)
    end

    def shared_libs
      @@shared_libs ||= load_and_initialize_gems('../apps/_gems', BootInquirer::SharedLib)
    end

    def engines
      self.shared_libs + self.apps
    end

    def engine(name)
      engines.detect{|e| e.name == name.to_s }
    end

    def enabled(collection = :engines)
      public_send(collection).select(&:enabled?)
    end

    def assets_required?
      !!enabled(:engines).detect(&:assets_required?)
    end

    def each_engine_with_assets
      enabled(:engines).select(&:assets_required?).each do |engine|
        yield engine
      end
    end

    def load_enabled_app_helpers
      enabled(:apps).map(&:load_helpers)
    end

    def derive_enabled_app_models
      enabled(:apps).map(&:derive_models_from_dependencies)
    end

    def boot_flag
      ENV['ENGINE_BOOT']
    end

    def negate?
      boot_flag.to_s =~ /^[\-\^]/
    end

    def boot_flag?(flag)
      return true if boot_flag.nil?
      default_value = !!boot_flag.to_s.index(flag)
      negate? ? !default_value : default_value
    end

    def method_missing(method_name, *args)
      if method_name.to_s =~ /(.+)\?$/
        self.engine($1).try(:enabled?) || super
      else
        self.engine(method_name) || super
      end
    end

  private

    def load_and_initialize_gems(path, klass = BootInquirer::Engine)
      full_path = File.expand_path(path, __dir__)

      gems = Dir.entries(full_path).select do |dir|
        dir.match?(/^[a-z][a-z0-9_-]+$/)
      end

      gems.map do |gem_name|
        klass.new(gem_name, File.join(full_path, gem_name))
      end
    end

  end

  class Engine

    attr_reader :key, :path, :name

    def initialize(key, path)
      @key = key
      @path = path
      @name = File.basename(path)
    end

    def namespace
      ns = name_parts.collect(&:classify).join('::')
      ns << 's' if name[-1] == 's'
      ns
    end

    def engine
      namespace.constantize.const_get(:Engine)
    end

    def require_path
      name_parts.join('/')
    end

    def root_url
      if ENV['DOMAIN'] != ''
        "#{ENV['FORCE_SSL'] ? 'https' : 'http'}://#{name}.#{ENV['DOMAIN']}"
      else
        raise 'You must set the DOMAIN in your environment'
      end
    end

    def assets_required?
      File.exists? asset_path
    end

    def asset_path
      File.join(path,'app/assets')
    end

    def gemspec
      File.join(path, "#{name}.gemspec")
    end

    def models
      @models ||= begin
        re = /^#{namespace}::/

        Rails.configuration.eager_load_namespaces.select do |ns|
          re.match?(ns.to_s)
        end.each(&:eager_load!)

        ApplicationRecord.descendants.select do |klass|
          re.match?(klass.to_s)
        end
      end
    end

    def dependencies
      @dependencies ||= begin
        deps = File.foreach(gemspec).
          grep(BootInquirer::DEPENDENCY_REGEXP).collect do |line|
            BootInquirer::DEPENDENCY_REGEXP.match(line)[1]
        end
        libs = BootInquirer.shared_libs.collect(&:name)
        deps.select{|dep| libs.include?(dep) }
      end
    end

    def load_helpers
      dependencies.each do |dep|
        app_controller = "#{namespace}::ApplicationController".constantize
        if app_controller.respond_to?(:helper)
          app_controller.class_eval do
            helper BootInquirer.engine(dep).engine.helpers
          end
        end
      end
    end

    def enabled?
      true
    end

  private

    def name_parts
      name.split(/[^a-z0-9_]/i)
    end

  end

  class SharedLib < Engine

    def enabled?
      deps = BootInquirer.enabled(:apps).collect do |app|
        app.dependencies
      end
      deps.flatten.include?(name)
    end

  end

  class App < Engine

    def enabled?
      BootInquirer.boot_flag?(@key)
    end

    # Using this method requires config.eager_load to be set to true
    def derive_models_from_dependencies
      dependencies.each do |dep|
        BootInquirer.engine(dep).models.each do |m|
          subclass_name = m.to_s.sub(/^[^:]+/, namespace)
          unless /ApplicationRecord/.match?(m.to_s) || Object.const_defined?(subclass_name)
            modules = subclass_name.split('::')
            klass = modules.pop
            ns = modules.inject('') do |ns, mod|
              obj = ns == '' ? Object : ns.constantize
              obj.const_set(mod, Module.new) unless obj.const_defined?(mod)
              ns << "::#{mod}"
            end
            ns.constantize.const_set klass, Class.new(m)
          end
        end
      end
      models
    end

  end

end