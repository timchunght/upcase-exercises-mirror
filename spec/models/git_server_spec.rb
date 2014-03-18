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
      FileUtils.mkdir_p "/tmp/#{GitServer::ADMIN_REPO_NAME}"

      begin
        shell = FakeShell.new
        git_server = GitServer.new(shell, 'host', '/tmp')
        exercise_name = 'new-exercise-name'
        shell_commands = [
          'git pull',
          "echo -e '\n\nrepo sources/#{exercise_name}\n" +
            "    RW+ = @admins\n' >> conf/gitolite.conf",
          'git add conf/gitolite.conf',
          "git commit -m 'add exercise: #{exercise_name}'",
          'git push'
        ]

        git_server.create_exercise(
          Repository.new(
            host: 'host',
            path: "sources/#{exercise_name}"
          )
        )

        shell_commands.each do |shell_command|
          expect(shell).to have_executed_command(shell_command)
        end
      ensure
        FileUtils.rm_rf "/tmp/#{GitServer::ADMIN_REPO_NAME}"
      end
    end
  end
end
