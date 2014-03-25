# Syncronizes the local key collection with the remote key collection.
class PublicKeySyncronizer
  def initialize(local_keys, remote_keys)
    @local_keys = local_keys
    @remote_keys = remote_keys
  end

  def syncronize
    @remote_keys.each do |remote_key|
      @local_keys.find_or_create_by!(data: remote_key)
    end
  end
end
