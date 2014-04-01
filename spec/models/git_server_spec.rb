require 'spec_helper'

describe GitServer do
  describe '#create_clone' do
    it 'executes a Gitolite fork command' do
      exercise = double('exercise', slug: 'exercise')
      user = double('user', username: 'username')
      shell = FakeShell.new
      git_server = build(:git_server, shell: shell, host: 'example.com')

      git_server.create_clone(exercise, user)

      expect(shell).to have_executed_command(
        'ssh git@example.com fork sources/exercise username/exercise'
      )
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

  def stub_config_committer_factory(committer)
    factory = double('config_committer_factory')
    git_server = yield(factory)
    factory.stub(:new).with(git_server: git_server).and_return(committer)
    git_server
  end
end
