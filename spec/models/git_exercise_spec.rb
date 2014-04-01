require 'spec_helper'

describe GitExercise do
  it 'decorates to its component' do
    exercise = double('exercise', title: 'expected title')
    git_server = double('git_server')
    git_exercise = GitExercise.new(exercise, git_server)

    expect(git_exercise).to be_a(SimpleDelegator)
    expect(git_exercise.title).to eq('expected title')
  end

  describe '#source' do
    it 'returns the source Git repository for this exercise' do
      repository = double('repository')
      exercise = double('exercise')
      git_server = double('git_server')
      git_server.stub(:source).with(exercise).and_return(repository)
      git_exercise = GitExercise.new(exercise, git_server)

      expect(git_exercise.source).to eq(repository)
    end
  end
end
