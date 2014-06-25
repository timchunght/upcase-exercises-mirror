require 'shell_stubber'

module Features
  def stub_git_commands
    Gitolite::FakeShell.with_stubs do |stubs|
      ShellStubber.new(stubs).
        clone_gitolite_admin_repo.
        head_sha.
        fingerprint

      yield
    end
  end
end

RSpec.configure do |config|
  config.around type: :feature do |example|
    stub_git_commands do
      example.run
    end
  end
end
