module Git
  class CloneObserver
    pattr_initialize [:clones!]

    def clone_created(exercise, user, sha)
      clones.create!(exercise: exercise, user: user, parent_sha: sha)
    end

    def diff_fetched(clone, diff)
      clone.create_revision!(diff: diff)
    end
  end
end
