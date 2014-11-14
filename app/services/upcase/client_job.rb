module Upcase
  class ClientJob
    pattr_initialize [:method_name, :data]

    def perform
      dependencies[:immediate_upcase_client].send(method_name, *data)
    end

    def error(job, exception)
      dependencies[:error_notifier].notify(exception)
    end

    private

    def dependencies
      Payload::RailsLoader.load
    end
  end
end
