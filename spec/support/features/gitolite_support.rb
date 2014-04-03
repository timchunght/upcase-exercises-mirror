module Features
  def stub_git_commands
    FakeShell.with_stubs do |stubs|
      stubs.add(%r{git clone [^ ]+gitolite-admin\.git (\w+)}) do |target|
        FileUtils.mkdir_p(File.join(target, 'conf'))
      end
      stubs.add(%r{git clone [^ ]+\.git (\w+)}) do |target|
        FileUtils.mkdir(target)
      end
      stubs.add(%r{git [^ ]+ rev-parse HEAD}) do
        '8586a6fc08b7ca29b41f'
      end

      yield
    end
  end

  def stub_diff_command(diff)
    FakeShell.with_stubs do |stubs|
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
