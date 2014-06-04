module Git
  class Observer
    pattr_initialize :clones

    def clone_created(exercise, user, sha)
      clones.create!(exercise: exercise, user: user, parent_sha: sha)
    end
  end
end
