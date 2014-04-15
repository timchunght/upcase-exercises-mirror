require 'spec_helper'

describe Gitolite::ClonableRepository do
  it_behaves_like :repository_decorator do
    def decorate(repository)
      Gitolite::ClonableRepository.new(repository, double('shell'))
    end
  end

  describe '#clone' do
    it 'creates temporarily cloned repository' do
      shell = Gitolite::FakeShell.new
      repository = double('repository', url: 'git@something:example.git')
      stub_clone do
        Gitolite::ClonableRepository.new(repository, shell).in_local_clone do
          expect(Dir.pwd).to match('local')
        end
      end
    end
  end

  def stub_clone
    Gitolite::FakeShell.with_stubs do |stubs|
      stubs.add(%r{git clone [^ ]+ (\w+)}) do |target|
        FileUtils.mkdir(target)
      end
      yield
    end
  end
end
