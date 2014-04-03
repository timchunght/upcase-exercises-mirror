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

    it 'sets the parent_sha from the HEAD commit' do
      git_server = double('git_server', create_clone: '123467')
      clone = build_stubbed(:clone)
      observer = GitObserver.new(git_server)

      expect { observer.clone_created(clone) }
        .to change { clone.parent_sha }.to '123467'
    end
  end

  describe '#solution_created' do
    it 'creates a Git diff' do
      git_server = double('git_server')
      git_server.stub(:create_diff)
      solution = build_stubbed(:solution)
      observer = GitObserver.new(git_server)

      observer.solution_created(solution)

      expect(git_server)
        .to have_received(:create_diff).with(solution, solution.clone)
    end

    it 'creates a diff from git server' do
      git_server = double('git_server', create_diff: 'diff deploy.rb')
      solution = build_stubbed(:solution)
      observer = GitObserver.new(git_server)

      observer.solution_created(solution)

      snapshot = solution.snapshot.reload
      expect(snapshot.diff).to eq('diff deploy.rb')
    end
  end
end
