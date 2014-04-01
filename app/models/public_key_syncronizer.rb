# Syncronizes the local key collection with the remote key collection.
class PublicKeySyncronizer
  def initialize(attributes)
    @git_server = attributes[:git_server]
    @local_keys = attributes[:local_keys]
    @remote_keys = attributes[:remote_keys]
    @user = attributes[:user]
  end

  def syncronize
    @remote_keys.each do |remote_key|
      unless @local_keys.exists?(data: remote_key)
        @local_keys.create!(data: remote_key)
        @git_server.add_key(@user.username)
      end
    end
  end
end
