module Features
  def stub_git_commands
    Gitolite::FakeShell.with_stubs do |stubs|
      stubs.add(%r{git clone [^ ]+gitolite-admin\.git}) do
        FileUtils.mkdir_p('conf')
      end

      stubs.add(%r{git rev-parse HEAD}) do
        '8586a6fc08b7ca29b41f'
      end

      yield
    end
  end

  def stub_diff_command(diff)
    Gitolite::FakeShell.with_stubs do |stubs|
      stubs.add(%r{git diff}) do
        diff
      end

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
