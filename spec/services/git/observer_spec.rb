require 'spec_helper'

describe Git::Observer do
  describe '#clone_created' do
    it 'creates a Git clone' do
      server = double('server')
      server.stub(:create_clone)
      clone = build_stubbed(:clone)
      observer = Git::Observer.new(server)

      observer.clone_created(clone)

      expect(server)
        .to have_received(:create_clone).with(clone.exercise, clone.user)
    end

    it 'sets the parent_sha from the HEAD commit' do
      server = double('server', create_clone: '123467')
      clone = build_stubbed(:clone)
      observer = Git::Observer.new(server)

      expect { observer.clone_created(clone) }
        .to change { clone.parent_sha }.to '123467'
    end
  end

  describe '#solution_created' do
    it 'creates a Git diff' do
      server = double('server')
      server.stub(:create_diff)
      solution = build_stubbed(:solution)
      observer = Git::Observer.new(server)

      observer.solution_created(solution)

      expect(server)
        .to have_received(:create_diff).with(solution, solution.clone)
    end

    it 'creates a diff from git server' do
      server = double('server', create_diff: 'diff deploy.rb')
      solution = build_stubbed(:solution)
      observer = Git::Observer.new(server)

      observer.solution_created(solution)

      snapshot = solution.snapshot.reload
      expect(snapshot.diff).to eq('diff deploy.rb')
    end
  end
end
