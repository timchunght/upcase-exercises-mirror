require 'spec_helper'

describe CommitCreator do
  describe '#commit' do
    it 'performs a commit in a local checkout' do
      in_temp_dir do
        shell = FakeShell.new
        repository = Repository.new(host: 'server', path: 'example')

        result = stub_clone do
          CommitCreator.new(shell, repository).commit('Message') do
            FileUtils.touch('example.txt')
          end
        end

        expect(result.added).to eq(['example.txt'])
        expect(result.committed).to eq(result.added)
        expect(result.pushed).to eq(result.committed)
        expect(result.message).to eq('Message')
      end
    end
  end

  def in_temp_dir
    Dir.mktmpdir do |path|
      Dir.chdir(path) do
        yield
      end
    end
  end

  def stub_clone
    state = CommitState.new

    FakeShell.with_stubs do |stubs|
      stubs.add(%r{git clone git@server:example\.git (\w+)}) do |target|
        FileUtils.mkdir(target)
      end

      stubs.add(%r{git add -A}) do
        state.add
      end

      stubs.add(%r{git commit -m "(.*)"}) do |message|
        state.commit message
      end

      stubs.add(%r{git push}) do
        state.push
      end

      yield
    end

    state
  end
end
