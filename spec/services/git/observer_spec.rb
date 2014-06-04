require 'spec_helper'

describe Git::Observer do
  describe '#clone_created' do
    it 'creates a local record of the clone' do
      sha = 'abc123'
      exercise = double('exercise')
      user = double('user')
      clone = double('clone')
      clones = double('clones')
      clones.
        stub(:create!).
        with(exercise: exercise, user: user, parent_sha: sha).
        and_return(clone)
      observer = Git::Observer.new(clones)

      result = observer.clone_created(exercise, user, sha)

      expect(result).to eq(clone)
    end
  end
end
