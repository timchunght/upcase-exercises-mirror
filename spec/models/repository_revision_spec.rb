require 'spec_helper'

describe RepositoryRevision do
  describe '#head' do
    it 'grabs the revision using the git server' do
      shell = FakeShell.new
      clonable = FakeClonableRepository.new
      result = stub_revision do
        RepositoryRevision.new(shell, clonable).head
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
