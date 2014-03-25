module Features
  def stub_gitolite_admin_clone
    FakeShell.with_stubs do |stubs|
      stubs.add(%r{git clone [^ ]+gitolite-admin\.git (\w+)}) do |target|
        FileUtils.mkdir_p(File.join(target, 'config'))
      end

      yield
    end
  end
end

RSpec.configure do |config|
  config.around type: :feature do |example|
    stub_gitolite_admin_clone do
      example.run
    end
  end
end
