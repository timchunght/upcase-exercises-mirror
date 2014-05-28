require 'spec_helper'

describe Review do
  describe '#exercise' do
    it 'returns its exercise' do
      exercise = double('exercise')
      review = build_review(exercise: exercise)

      result = review.exercise

      expect(result).to eq(exercise)
    end
  end

  describe '#has_solutions_by_other_users?' do
    it "returns true with solutions besides the current user's" do
      other_solution = stub_solution('other_solution')
      review = build_review(other_solutions: [other_solution])

      expect(review).to have_solutions_by_other_users
    end

    it 'returns false with only the submitted solution' do
      review = build_review(other_solutions: [])

      expect(review).not_to have_solutions_by_other_users
    end
  end

  describe '#viewed_solution' do
    it 'returns its viewed solution' do
      viewed_solution = double('viewed_solution')
      review = build_review(viewed_solution: viewed_solution)

      expect(review.viewed_solution).to eq(viewed_solution)
    end
  end

  describe '#latest_revision' do
    it 'delegates to the viewed solution' do
      viewed_solution = double('viewed_solution', latest_revision: nil)
      review = build_review(viewed_solution: viewed_solution)

      review.latest_revision

      expect(viewed_solution).to have_received(:latest_revision)
    end
  end

  describe '#submitted?' do
    context 'with a submitted solution' do
      it 'returns true' do
        review = build_review(submitted_solution: double('submitted_solution'))

        expect(review).to be_submitted
      end
    end

    context 'without a submitted solution' do
      it 'returns false' do
        review = build_review(submitted_solution: nil)

        expect(review).not_to be_submitted
      end
    end
  end

  describe '#solutions_by_other_users' do
    it "returns solutions besides the current user's" do
      submitted_solution = stub_solution('submitted_solution')
      viewed_solution = stub_solution('viewed_solution')
      other_solution = stub_solution('other_solution')
      review = build_review(
        other_solutions: [other_solution, viewed_solution],
        submitted_solution: submitted_solution,
        viewed_solution: viewed_solution
      )

      result = review.solutions_by_other_users

      expect(result.map(&:name)).to eq(%w(other_solution viewed_solution))
      expect(result[0]).to be_assigned
      expect(result[0]).not_to be_active
      expect(result[1]).to be_active
      expect(result[1]).not_to be_assigned
    end
  end

  describe '#assigned_solution' do
    it 'returns the first solution from another user' do
      other_solutions =
        [stub_solution('first_other'), stub_solution('second_other')]
      review = build_review(other_solutions: other_solutions)

      expect(review.assigned_solution).to eq other_solutions.first
    end

    it 'assigns the submitted solution without another solution' do
      submitted_solution = stub_solution('submitted_solution')
      review = build_review(
        other_solutions: [],
        submitted_solution: submitted_solution
      )

      expect(review.assigned_solution).to eq submitted_solution
    end
  end

  describe '#assigned_solver' do
    it 'returns the first solver besides the reviewer' do
      submitted_solution = stub_solution('submitted_solution')
      other_solutions = [
        stub_solution('first_other', user: 'first user'),
        stub_solution('second_other', user: 'second user')
      ]
      review = build_review(
        other_solutions: other_solutions,
        submitted_solution: submitted_solution,
        viewed_solution: stub_solution('viewed_solution'),
      )

      expect(review.assigned_solver).to eq 'first user'
    end
  end

  describe '#submitted_solution' do
    it 'returns the solution for the reviewing user' do
      submitted_solution = stub_solution('submitted_solution')
      review = build_review(
        submitted_solution: submitted_solution,
        viewed_solution: stub_solution('viewed_solution')
      )

      result = review.my_solution

      expect(result).to eq submitted_solution
      expect(result).not_to be_active
      expect(result).not_to be_assigned
    end
  end

  describe '#files' do
    it 'delegates to its viewed solution' do
      files = double('files')
      viewed_solution = double('solution', files: files)
      review = build_review(viewed_solution: viewed_solution)

      result = review.files

      expect(result).to eq(files)
    end
  end

  describe '#comments' do
    it 'delegates to its viewed solution' do
      comments = double('comments')
      viewed_solution = double('solution', comments: comments)
      review = build_review(viewed_solution: viewed_solution)

      result = review.comments

      expect(result).to eq(comments)
    end
  end

  def build_review(
    submitted_solution: stub_solution('submitted_solution'),
    other_solutions: [stub_solution('other_solution')],
    viewed_solution: submitted_solution || other_solutions.first,
    exercise: double('exercise')
  )
    solutions = [submitted_solution, *other_solutions].compact
    Review.new(
      exercise: exercise,
      solutions: solutions,
      submitted_solution: submitted_solution,
      viewed_solution: viewed_solution
    )
  end

  def stub_solution(name, attributes = {})
    double(name, attributes.merge(name: name)).tap do |solution|
      solution.stub(:id).and_return(solution.object_id)
    end
  end
end
