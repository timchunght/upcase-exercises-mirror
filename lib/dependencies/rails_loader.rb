require 'dependencies/container'

module Dependencies
  # Loads dependencies from config/dependencies.rb in Rails applications.
  #
  # Used by Railtie to provide a Rails dependency loader to RackContainer.
  class RailsLoader
    def to_proc
      lambda { load }
    end

    private

    def load
      Dependencies::Container.new.instance_eval(config, config_path)
    end

    def config
      IO.read(config_path)
    end

    def config_path
      Rails.root.join('config', 'dependencies.rb').to_s
    end
  end
end
