class ShellStubber
  pattr_initialize :stubs

  def clone_gitolite_admin_repo
    stubs.add(%r{git clone [^ ]+gitolite-admin\.git}) do
      FileUtils.mkdir_p('conf')
    end
    self
  end

  def head_sha(sha = 'abcdef1234567890abcdef1234567890abcdef10')
    stubs.add(%r{git rev-parse HEAD}) { sha }
    self
  end

  def diff(diff = 'diff example.txt')
    stubs.add(%r{git diff}) { diff }
    self
  end
end
