module Git
  # Determines which Pusher channel to use for events related to a user and
  # exercise.
  class CloneChannel
    PREFIX = "clone"

    pattr_initialize [:exercise!, :pusher!, :user!]

    def name
      "#{PREFIX}.#{exercise.id}.#{user.id}"
    end

    def trigger(event)
      channel.trigger(event, "")
    end

    private

    def channel
      pusher[name]
    end
  end
end
