require 'spec_helper'

describe GitClone do
  it 'decorates to its component' do
    clone = double('clone', title: 'expected title')
    git_server = double('git_server')
    git_clone = GitClone.new(clone, git_server)

    expect(git_clone).to be_a(SimpleDelegator)
    expect(git_clone.title).to eq('expected title')
  end

  describe '#repository' do
    it 'returns the repository for itself' do
      user = double('user')
      exercise = double('exercise')
      repository = double('repository')
      git_server = double('git_server')
      git_server.stub(:clone).with(exercise, user).and_return(repository)
      clone = double('clone', user: user, exercise: exercise)
      git_clone = GitClone.new(clone, git_server)

      result = git_clone.repository

      expect(result).to eq(repository)
    end
  end
end
