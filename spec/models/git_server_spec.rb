require 'spec_helper'

describe GitServer do
  describe '#exercise_url' do
    it 'returns the full url of the given repository' do
      repository = double('repository', exercise_path: 'exercises/repo')

      exercise_url = build_git_server.exercise_url(repository)

      expect(exercise_url).to eq('git@host:exercises/repo.git')
    end
  end

  describe '#has_gitolite_repo?' do
    it 'returns true if the repo exists' do
      `mkdir -p /tmp/#{GitServer::ADMIN_REPO_NAME}`

      begin
        expect(build_git_server).to have_gitolite_repo
      ensure
        `rm -rf /tmp/#{GitServer::ADMIN_REPO_NAME}`
      end
    end

    it 'returns false if the repo does not exist' do
      expect(build_git_server).not_to have_gitolite_repo
    end
  end

  def build_git_server
    GitServer.new(FakeShell.new, 'host', '/tmp')
  end
end
