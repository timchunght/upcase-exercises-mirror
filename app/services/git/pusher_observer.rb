module Git
  # Notifies Pusher when server-side changes occur so that the UI can update.
  class PusherObserver
    pattr_initialize :channel_factory

    def clone_created(exercise, user, _sha)
      channel_factory.new(exercise: exercise, user: user).trigger("cloned")
    end

    def diff_fetched(clone, _diff)
      channel_factory.
        new(exercise: clone.exercise, user: clone.user).
        trigger("pushed")
    end
  end
end
