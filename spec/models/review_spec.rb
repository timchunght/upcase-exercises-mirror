require 'spec_helper'

describe Review do
  describe '#exercise' do
    it 'returns its exercise' do
      exercise = double('exercise')
      review = Review.new(
        exercise: exercise,
        viewed_solution: double('viewed_solution'),
        submitted_solution: double('submitted_solution')
      )

      result = review.exercise

      expect(result).to eq(exercise)
    end
  end

  describe '#viewed_solution' do
    it 'returns its viewed solution' do
      viewed_solution = double('viewed_solution')
      review = Review.new(
        exercise: double('exercise'),
        viewed_solution: viewed_solution,
        submitted_solution: double('submitted_solution')
      )

      expect(review.viewed_solution).to eq(viewed_solution)
    end
  end

  describe '#submitted?' do
    context 'with a submitted solution' do
      it 'returns true' do
        review = Review.new(
          exercise: double('exercise'),
          viewed_solution: double('viewed_solution'),
          submitted_solution: double('submitted_solution')
        )

        expect(review).to be_submitted
      end
    end

    context 'without a submitted solution' do
      it 'returns false' do
        review = Review.new(
          exercise: double('exercise'),
          viewed_solution: double('viewed_solution'),
          submitted_solution: nil
        )

        expect(review).not_to be_submitted
      end
    end
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
      review = Review.new(
        exercise: exercise,
        viewed_solution: active_solution,
        submitted_solution: my_solution
      )

      result = review.solutions_by_other_users

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
      review = Review.new(
        exercise: exercise,
        viewed_solution: stub_solution('active_solution'),
        submitted_solution: my_solution
      )

      expect(review.assigned_solution).to eq other_solutions.first
    end
  end

  describe '#assigned_solver' do
    it 'returns the first solver besides the reviewer' do
      my_solution = stub_solution('my_solution')
      other_solutions =
        [stub_solution('first_other', user: 'first user'),
         stub_solution('second_other', user: 'second user')]
      exercise = stub_exercise_with_solutions(
        my_solution,
        other_solutions
      )
      review = Review.new(
        exercise: exercise,
        viewed_solution: stub_solution('active_solution'),
        submitted_solution: my_solution
      )

      expect(review.assigned_solver).to eq 'first user'
    end
  end

  describe '#my_solution' do
    it 'returns the solution for the reviewing user' do
      my_solution = stub_solution('my_solution')
      exercise = stub_exercise_with_solutions(
        my_solution,
        []
      )
      review = Review.new(
        exercise: exercise,
        viewed_solution: stub_solution('active_solution'),
        submitted_solution: my_solution
      )

      result = review.my_solution

      expect(result).to eq my_solution
      expect(result).not_to be_active
      expect(result).not_to be_assigned
    end
  end

  describe '#files' do
    it 'delegates to its viewed solution' do
      files = double('files')
      viewed_solution = double('solution', files: files)
      review = Review.new(
        exercise: double('exercise'),
        viewed_solution: viewed_solution,
        submitted_solution: double('user')
      )

      result = review.files

      expect(result).to eq(files)
    end
  end

  describe '#comments' do
    it 'delegates to its viewed solution' do
      comments = double('comments')
      viewed_solution = double('solution', comments: comments)
      review = Review.new(
        exercise: double('exercise'),
        viewed_solution: viewed_solution,
        submitted_solution: double('user')
      )

      result = review.comments

      expect(result).to eq(comments)
    end
  end

  def stub_exercise_with_solutions(my_solution, other_solutions)
    double('exercise').tap do |exercise|
      exercise.stub(:solutions).and_return([my_solution, *other_solutions])
    end
  end

  def stub_solution(name, attributes = {})
    double(name, attributes.merge(name: name)).tap do |solution|
      solution.stub(:id).and_return(solution.object_id)
    end
  end
end
