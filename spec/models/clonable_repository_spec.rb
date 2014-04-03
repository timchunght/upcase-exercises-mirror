require 'spec_helper'

describe ClonableRepository do
  describe '#clone' do
    it 'creates temporarily cloned repository' do
      shell = FakeShell.new
      repository = double('repository', url: 'git@something:example.git')
      stub_clone do
        ClonableRepository.new(shell, repository).clone do
          expect(Dir.pwd).to match('local')
        end
      end
    end
  end

  def stub_clone
    FakeShell.with_stubs do |stubs|
      stubs.add(%r{git clone [^ ]+ (\w+)}) do |target|
        FileUtils.mkdir(target)
      end
      yield
    end
  end
end
