# This determines which engines to boot / mount within the operator app (v3).
# The boot flag is a collection of characters representing the different engines in this project
# For example:
#   ~> ENGINE_BOOT=am bundle exec rails c
#   => will boot the account and marketing engines - but not content, admin, etc.
#
# The boot flag can be negated to have the opposite effect.
# For example:
#   ~> ENGINE_BOOT=-m bundle exec rails c
#   => will boot all engines except marketing
#
# The boot flag characters are not necessarily the first letter of each engine name, so check this file if you're using boot flags.
#
# When Rails.env is "test" all boot flags are assumed to be present, no matter what you provide.

class BootInquirer

  DEPENDENCY_REGEXP = /dependency\s+(?:'|")(.+?)(?:'|")/i

  class << self

    def engines
      self.shared_libs + self.apps
    end

    def apps
      @@apps ||= load_and_initialize_gems('../apps', BootInquirer::App)
    end

    def shared_libs
      @@shared_libs ||= load_and_initialize_gems('../apps/_common', BootInquirer::SharedLib)
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

    def boot_flag
      @@boot_flag ||= ENV['ENGINE_BOOT']
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
        app = apps.detect{|app| app.name == $1}
        if app
          app.enabled?
        else
          super
        end
      else
        super
      end
    end

  private

    def load_and_initialize_gems(path, klass = BootInquirer::Engine)
      full_path = File.expand_path(path, __dir__)

      gems = Dir.entries(full_path).select do |dir|
        dir.match?(/^[a-z][a-z0-9_]+$/)
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

    def engine
      module_name = name.classify
      module_name << 's' if name[-1] == 's'
      module_name.constantize.const_get(:Engine)
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

    def dependencies
      @dependencies ||= File.foreach(gemspec).
        grep(BootInquirer::DEPENDENCY_REGEXP).collect do |line|
          BootInquirer::DEPENDENCY_REGEXP.match(line)[1]
      end
    end

    def enabled?
      true
    end

  end

  class SharedLib < Engine

    def enabled?
      deps = []
      BootInquirer.enabled(:apps).each do |app|
        deps << app.dependencies
      end
      deps.flatten.include?(name)
    end

  end

  class App < Engine

    def enabled?
      BootInquirer.boot_flag?(@key)
    end

  end

end