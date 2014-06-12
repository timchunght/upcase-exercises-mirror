require 'spec_helper'

describe Git::CloneObserver do
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
      observer = Git::CloneObserver.new(clones: clones)

      result = observer.clone_created(exercise, user, sha)

      expect(result).to eq(clone)
    end
  end

  describe '#diff_fetched' do
    it 'creates a new revision' do
      diff = '--- +++'
      clone = double('clone')
      clone.stub(:create_revision!)
      observer = Git::CloneObserver.new(clones: double('clones'))

      observer.diff_fetched(clone, diff)

      expect(clone).to have_received(:create_revision!).with(diff: diff)
    end
  end
end
