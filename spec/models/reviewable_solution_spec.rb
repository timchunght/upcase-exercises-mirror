require 'spec_helper'

describe ReviewableSolution do
  it 'delegates attributes to its solution' do
    solution = build_stubbed(:solution)
    reviewable_solution = ReviewableSolution.new(
      exercise: double('exercise'),
      viewed_solution: solution,
      submitted_solution: double('solution')
    )

    expect(reviewable_solution.user).to eq(solution.user)
    expect(reviewable_solution).to be_a(SimpleDelegator)
  end

  describe '#solutions_by_other_users' do
    it "returns solutions besides the current user's" do
      my_solution = stub_solution('my_solution')
      active_solution = stub_solution('active_solution')
      other_solution = stub_solution('other_solution')
      exercise = stub_exercise_with_solutions(
        my_solution,
        [other_solution, active_solution]
      )
      reviewable_solution = ReviewableSolution.new(
        exercise: exercise,
        viewed_solution: active_solution,
        submitted_solution: my_solution
      )

      result = reviewable_solution.solutions_by_other_users

      expect(result.map(&:name)).to eq(%w(other_solution active_solution))
      expect(result[0]).to be_assigned
      expect(result[0]).not_to be_active
      expect(result[1]).to be_active
      expect(result[1]).not_to be_assigned
    end
  end

  describe '#assigned_solution' do
    it 'returns the first solution from another user' do
      my_solution = stub_solution('my_solution')
      other_solutions =
        [stub_solution('first_other'), stub_solution('second_other')]
      exercise = stub_exercise_with_solutions(
        my_solution,
        other_solutions
      )
      reviewable_solution = ReviewableSolution.new(
        exercise: exercise,
        viewed_solution: double('active_solution'),
        submitted_solution: my_solution
      )

      expect(reviewable_solution.assigned_solution).to eq other_solutions.first
    end
  end

  describe '#my_solution' do
    it 'returns the solution for the reviewing user' do
      my_solution = stub_solution('my_solution')
      exercise = stub_exercise_with_solutions(
        my_solution,
        []
      )
      reviewable_solution = ReviewableSolution.new(
        exercise: exercise,
        viewed_solution: double('active_solution'),
        submitted_solution: my_solution
      )

      result = reviewable_solution.my_solution

      expect(result).to eq my_solution
      expect(result).not_to be_active
      expect(result).not_to be_assigned
    end
  end

  def stub_exercise_with_solutions(my_solution, other_solutions)
    double('exercise').tap do |exercise|
      exercise.stub(:solutions).and_return([my_solution, *other_solutions])
    end
  end

  def stub_solution(name)
    double(name, name: name)
  end
end
