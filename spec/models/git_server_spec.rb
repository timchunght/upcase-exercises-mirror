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

  describe '#has_gitolite_repo?' do
    it 'returns true if the repo exists' do
      `mkdir -p /tmp/#{GitServer::ADMIN_REPO_NAME}`

      begin
        expect(build(:git_server)).to have_gitolite_repo
      ensure
        `rm -rf /tmp/#{GitServer::ADMIN_REPO_NAME}`
      end
    end

    it 'returns false if the repo does not exist' do
      expect(build(:git_server)).not_to have_gitolite_repo
    end
  end
end
