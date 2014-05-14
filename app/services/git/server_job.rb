module Git
  class ServerJob
    pattr_initialize [:method_name, :data]

    def perform
      dependencies[:immediate_git_server].send(method_name, *data)
    end

    private

    def dependencies
      Dependencies::RailsLoader.load
    end
  end
end
