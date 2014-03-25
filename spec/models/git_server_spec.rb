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
        'command ssh git@example.com fork sources/exercise username/exercise'
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
    it 'executes the correct shell commands' do
      exercise_name = 'new-exercise-name'
      host = 'example.com'
      shell = FakeShell.new
      gitolite_config = stub_gitolite_config
      checkout = stub_checkout(host, shell)

      git_server = build(:git_server, shell: shell, host: host)

      git_server.create_exercise(
        Repository.new(
          host: host,
          path: "sources/#{exercise_name}"
        )
      )

      expect(gitolite_config).to have_received(:write)
      expect(checkout).to have_received(:commit)
        .with("Add exercise: #{exercise_name}")
    end

    def stub_gitolite_config
      double('gitolite_config').tap do |config|
        GitoliteConfig.stub(:new).with('.').and_return(config)
        config.stub(:write)
      end
    end

    def stub_checkout(host, shell)
      double('checkout').tap do |checkout|
        remote_repository =
          Repository.new(host: host, path: GitServer::ADMIN_REPO_NAME)
        CommitCreator
          .stub(:new)
          .with(shell, remote_repository)
          .and_return(checkout)
        checkout.stub(:commit).and_yield
      end
    end
  end

  let(:admin_repo_path) { "/tmp/#{GitServer::ADMIN_REPO_NAME}" }
end
