require 'spec_helper'

describe Git::Solution do
  it 'delegates attributes to its solution' do
    revision = build_stubbed(:revision)
    git_solution = Git::Solution.new(revision, double('parser_factory'))

    expect(git_solution.solution).to eq(revision.solution)
    expect(git_solution).to be_a(SimpleDelegator)
  end

  describe '#files' do
    it 'delegates to a diff parser' do
      diff = 'diff example.txt'
      files = double('files')
      parser = double('parser', parse: files)
      parser_factory = double('parser_factory')
      parser_factory.stub(:new).with(diff: diff).and_return(parser)
      revision = build_stubbed(:revision, diff: diff)
      git_solution = Git::Solution.new(revision, parser_factory)

      result = git_solution.files

      expect(result).to eq(files)
    end
  end
end
