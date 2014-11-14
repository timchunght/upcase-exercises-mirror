module Upcase
  class BackgroundClient
    pattr_initialize :client, :job_factory

    def update_status(*args)
      job_factory.new(method_name: 'update_status', data: args)
    end

    def synchronize_exercise(*args)
      job_factory.new(method_name: 'synchronize_exercise', data: args)
    end
  end
end
