require 'spec_helper'

describe GitServer do
  describe '#create_clone' do
    it 'executes a Gitolite fork command' do
      exercise = double('exercise', slug: 'exercise')
      user = double('user', username: 'username')
      shell = FakeShell.new
      git_server = stub_clonable_git_server(shell)
      stub_revision

      git_server.create_clone(exercise, user)

      expect(shell).to have_executed_command(
        'ssh git@example.com fork sources/exercise username/exercise'
      )
    end

    it 'returns the HEAD revision of the repo it forked from' do
      exercise = double('exercise', slug: 'exercise')
      user = double('user', username: 'username')
      git_server = stub_clonable_git_server
      stub_revision('1234567')

      result = git_server.create_clone(exercise, user)

      expect(result).to eq '1234567'
    end
  end

  describe '#clone' do
    it 'returns a repository for the clone' do
      user = double('user', username: 'username')
      exercise = double('exercise', slug: 'exercise')

      clone = build(:git_server, host: 'example.com').clone(exercise, user)

      expect(clone)
        .to eq(Repository.new(host: 'example.com', path: 'username/exercise'))
    end
  end

  describe '#source' do
    it 'returns the source repository for the given exercise' do
      exercise = double('exercise', slug: 'exercise')

      source = build(:git_server, host: 'example.com').source(exercise)

      expect(source)
        .to eq(Repository.new(host: 'example.com', path: 'sources/exercise'))
    end
  end

  describe '#create_diff' do
    it 'updates the solution with a new diff' do
      clone = build_stubbed(:clone, parent_sha: 'a_sha')
      solution = build_stubbed(:solution)
      git_server = stub_clonable_git_server
      diff_creator = double('diff_creator')
      DiffCreator.stub(:new).and_return(diff_creator)
      diff_creator.stub(:diff)

      git_server.create_diff(solution, clone)

      expect(diff_creator).to have_received(:diff).with('a_sha')
    end
  end

  describe '#create_exercise' do
    it 'rewrites the Gitolite config' do
      exercise_name = 'new-exercise-name'
      host = 'example.com'
      config_committer = stub_config_committer
      git_server = stub_config_committer_factory(config_committer) do |factory|
        build(
          :git_server,
          host: host,
          config_committer_factory: factory
        )
      end

      git_server.create_exercise(
        Repository.new(
          host: host,
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
      git_server = stub_config_committer_factory(config_committer) do |factory|
        build(:git_server, config_committer_factory: factory)
      end

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

  def stub_clonable_repository
    double('clonable_repository').tap do |clonable_repository|
      clonable_repository.stub(:clone)
    end
  end

  def stub_config_committer_factory(committer)
    factory = double('config_committer_factory')
    git_server = yield(factory)
    factory.stub(:new).with(git_server: git_server).and_return(committer)
    git_server
  end

  def stub_clonable_repository_factory(clonable_repository)
    factory = double('clonable_repository_factory')
    git_server = yield(factory)
    factory.stub(:new).and_return(clonable_repository)
    git_server
  end

  def stub_revision(revision = nil)
    revision = double('revision', head: revision)
    RepositoryRevision.stub(:new).and_return(revision)
  end

  def stub_clonable_git_server(shell = FakeShell.new)
    clonable_repository = stub_clonable_repository
    git_server =
      stub_clonable_repository_factory(clonable_repository) do |factory|
        build(
          :git_server,
          shell: shell,
          host: 'example.com',
          clonable_repository_factory: factory
        )
      end
    git_server
  end
end
