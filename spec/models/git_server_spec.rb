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
      FileUtils.mkdir_p admin_repo_path
      gitolite_config = double('gitolite_config')
      GitoliteConfig
        .stub(:new)
        .with(admin_repo_path)
        .and_return(gitolite_config)
      gitolite_config.stub(:write)

      begin
        shell = FakeShell.new
        git_server = GitServer.new(shell, 'host', '/tmp')
        exercise_name = 'new-exercise-name'

        git_server.create_exercise(
          Repository.new(
            host: 'host',
            path: "sources/#{exercise_name}"
          )
        )

        expect(shell).to have_executed_commands(
          'git pull',
          'git add conf/gitolite.conf',
          "git commit -m 'Add exercise: #{exercise_name}'",
          'git push'
        )
        expect(gitolite_config).to have_received(:write)
      ensure
        FileUtils.rm_rf admin_repo_path
      end
    end
  end

  let(:admin_repo_path) { "/tmp/#{GitServer::ADMIN_REPO_NAME}" }
end
