# Syncronizes the local key collection with the remote key collection.
class PublicKeySyncronizer
  def initialize(user, local_keys, remote_keys)
    @local_keys = local_keys
    @remote_keys = remote_keys
    @user = user
  end

  def syncronize
    @remote_keys.each do |remote_key|
      unless @local_keys.exists?(data: remote_key)
        @local_keys.create!(data: remote_key)
        GIT_SERVER.add_key(@user.username)
      end
    end
  end
end
