require 'spec_helper'

describe GitObserver do
  describe '#clone_created' do
    it 'creates a Git clone' do
      git_server = double('git_server')
      git_server.stub(:create_clone)
      clone = build_stubbed(:clone)
      observer = GitObserver.new(git_server)

      observer.clone_created(clone)

      expect(git_server)
        .to have_received(:create_clone).with(clone.exercise, clone.user)
    end
  end
end
