module Gitolite
  # Syncronizes the local key collection with the remote key collection.
  class PublicKeySyncronizer
    pattr_initialize [:server, :local_keys, :remote_keys, :user]

    def syncronize
      remote_keys.each do |remote_key|
        unless local_keys.exists?(data: remote_key)
          local_keys.create!(data: remote_key)
          server.add_key(user.username)
        end
      end
    end
  end
end
