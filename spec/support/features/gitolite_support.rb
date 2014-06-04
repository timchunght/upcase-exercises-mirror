module Features
  def stub_git_commands
    Gitolite::FakeShell.with_stubs do |stubs|
      stubs.add(%r{git clone [^ ]+gitolite-admin\.git}) do
        FileUtils.mkdir_p('conf')
      end

      stubs.add(%r{git rev-parse HEAD}) do
        'abcdef1234567890abcdef1234567890abcdef10'
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
