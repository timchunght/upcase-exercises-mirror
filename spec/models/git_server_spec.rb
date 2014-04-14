require 'spec_helper'

describe GitServer do
  describe '#create_clone' do
    it 'creates a Gitolite fork and returns the current HEAD' do
      exercise = double('exercise', slug: 'exercise')
      user = double('user', username: 'username')
      source = double('source')
      source.stub(:create_fork)
      clone = double('clone', path: 'username/exercise')
      clone.stub(:head).and_return('sha123')
      repository_finder = double('repository_finder')
      repository_finder.stub(:find_source).with(exercise).and_return(source)
      repository_finder.stub(:find_clone).with(exercise, user).and_return(clone)
      git_server = build(:git_server, repository_finder: repository_finder)

      result = git_server.create_clone(exercise, user)

      expect(source).to have_received(:create_fork).with('username/exercise')
      expect(result).to eq('sha123')
    end
  end

  describe '#find_clone' do
    it 'delegates to its repository finder' do
      user = double('user')
      exercise = double('exercise')
      repository = double('repository')
      repository_finder = double('repository_finder')
      repository_finder
        .stub(:find_clone)
        .with(exercise, user)
        .and_return(repository)
      git_server = build(:git_server, repository_finder: repository_finder)

      clone = git_server.find_clone(exercise, user)

      expect(clone).to eq(repository)
    end
  end

  describe '#find_source' do
    it 'delegates to its repository finder' do
      exercise = double('exercise')
      repository = double('repository')
      repository_finder = double('repository_finder')
      repository_finder
        .stub(:find_source)
        .with(exercise)
        .and_return(repository)
      git_server = build(:git_server, repository_finder: repository_finder)

      source = git_server.find_source(exercise)

      expect(source).to eq(repository)
    end
  end

  describe '#create_diff' do
    it 'updates the solution with a new diff' do
      clone = build_stubbed(:clone, parent_sha: 'a_sha')
      solution = build_stubbed(:solution)
      diff = '--- +++'
      repository = double('repository')
      repository.stub(:diff).with('a_sha').and_return(diff)
      repository_finder = double('repository_finder')
      repository_finder
        .stub(:find_clone)
        .with(clone.exercise, clone.user)
        .and_return(repository)
      git_server = build(:git_server, repository_finder: repository_finder)

      result = git_server.create_diff(solution, clone)

      expect(result).to eq(diff)
    end
  end

  describe '#create_exercise' do
    it 'rewrites the Gitolite config' do
      exercise_name = 'new-exercise-name'
      config_committer = stub_config_committer
      git_server = build(:git_server, config_committer: config_committer)

      git_server.create_exercise(
        Repository.new(
          path: "sources/#{exercise_name}"
        )
      )

      expect(config_committer).to have_received(:write)
        .with("Add exercise: #{exercise_name}")
    end
  end

  describe '#add_key' do
    it 'rewrites the Gitolite config' do
      username = 'mrunix'
      config_committer = stub_config_committer
      git_server = build(:git_server, config_committer: config_committer)

      git_server.add_key(username)

      expect(config_committer).to have_received(:write)
        .with("Add public key for user: #{username}")
    end
  end

  def stub_config_committer
    double('config_committer').tap do |config_committer|
      config_committer.stub(:write)
    end
  end
end
