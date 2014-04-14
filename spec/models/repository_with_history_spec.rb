require 'spec_helper'

describe RepositoryWithHistory do
  it_behaves_like :repository_decorator do
    def decorate(repository)
      RepositoryWithHistory.new(repository, double('shell'))
    end
  end

  describe '#head' do
    it 'grabs the revision using the git server' do
      shell = FakeShell.new
      repository = FakeClonableRepository.new
      result = stub_revision do
        RepositoryWithHistory.new(repository, shell).head
      end

      expect(result).to eq '05aa1bb6146da8d041eb37c4931e'
    end
  end

  def stub_revision
    FakeShell.with_stubs do |stubs|
      stubs.add(%r{git rev-parse HEAD}) do
        '05aa1bb6146da8d041eb37c4931e'
      end

      yield
    end
  end
end
