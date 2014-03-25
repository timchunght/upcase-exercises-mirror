require 'spec_helper'

describe GitoliteConfigCommitter do
  describe '#write' do
    it 'clones the config, rewrites it, and pushes it' do
      host = 'example.com'
      message = 'Updated config'
      shell = FakeShell.new
      writer = stub_writer
      commit_creator = stub_commit_creator(host, shell)
      gitolite_config_committer = GitoliteConfigCommitter.new(
        host: host,
        shell: shell,
        writer: writer
      )

      gitolite_config_committer.write(message)

      expect(writer).to have_received(:write)
      expect(commit_creator).to have_received(:commit).with(message)
    end

    def stub_writer
      double('gitolite_config_writer').tap do |config|
        config.stub(:write)
      end
    end

    def stub_commit_creator(host, shell)
      double('commit_creator').tap do |commit_creator|
        remote_repository = Repository.new(
          host: host,
          path: GitoliteConfigCommitter::ADMIN_REPO_NAME
        )
        CommitCreator
          .stub(:new)
          .with(shell, remote_repository)
          .and_return(commit_creator)
        commit_creator.stub(:commit).and_yield
      end
    end
  end
end
