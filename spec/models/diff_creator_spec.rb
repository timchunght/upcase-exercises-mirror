require 'spec_helper'

describe DiffCreator do
  describe '#diff' do
    it 'performs a diff in the local directory' do
      shell = FakeShell.new
      clonable = FakeClonableRepository.new
      diff_creator = DiffCreator.new(shell, clonable)

      stub_diff do
        diff_creator.diff('some_sha')
      end

      expect(shell).to have_executed_command(
        'git diff some_sha --unified=10000'
      )
    end

    def stub_diff
      FakeShell.with_stubs do |stubs|
        stubs.add(%r{git diff}) do |target|
          'diff deploy.rb'
        end

        yield
      end
    end
  end
end
