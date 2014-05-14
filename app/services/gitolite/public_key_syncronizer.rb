module Gitolite
  # Syncronizes the local key collection with the remote key collection.
  class PublicKeySyncronizer
    include ::NewRelic::Agent::MethodTracer

    pattr_initialize [:server, :local_keys, :remote_keys, :user]

    def syncronize
      remote_keys.each do |remote_key|
        unless exists_locally?(remote_key)
          create_local(remote_key)
          add_to_server
        end
      end
    end

    private

    def exists_locally?(data)
      local_keys.exists?(data: data)
    end

    def create_local(data)
      local_keys.create!(data: data)
    end

    def add_to_server
      server.add_key(user.username)
    end

    add_method_tracer :add_to_server
    add_method_tracer :create_local
    add_method_tracer :exists_locally?
    add_method_tracer :remote_keys
    add_method_tracer :syncronize
  end
end
