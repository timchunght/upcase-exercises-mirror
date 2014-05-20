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

  describe '#status' do
    it 'build status from its factory' do
      status_factory = double('status_factory')
      status = double('status')
      status_factory.stub(:new).and_return(status)
      review = build_review(status_factory: status_factory)

      result = review.status

      expect(result).to eq(status)
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

  describe '#assigned_solver_username' do
    it 'returns the username of the first solver besides the reviewer' do
      submitted_solution = stub_solution('submitted_solution')
      other_solutions = [
        stub_solution('first_other', username: 'first username'),
        stub_solution('second_other', username: 'second username')
      ]
      review = build_review(
        other_solutions: other_solutions,
        submitted_solution: submitted_solution,
        viewed_solution: stub_solution('viewed_solution'),
      )

      expect(review.assigned_solver_username).to eq 'first username'
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

      expect(review.assigned_solver).to eq('first user')
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

  describe '#top_level_comments' do
    it 'delegates to its comment finder' do
      top_level_comments = double('comment_locator.top_level_comments')
      comment_locator = double('comment_locator')
      comment_locator.stub(:top_level_comments).and_return(top_level_comments)
      review = build_review(comment_locator: comment_locator)

      result = review.top_level_comments

      expect(result).to eq(top_level_comments)
    end
  end

  describe '#viewing_other_solution?' do
    context "when viewing a solution other than the user's" do
      it 'returns true' do
        submitted_solution = stub_solution('submitted_solution')
        viewed_solution = stub_solution('viewed_solution')
        review = build_review(
                   viewed_solution: viewed_solution,
                   submitted_solution: submitted_solution
                 )

        result = review.viewing_other_solution?

        expect(result).to be_true
      end
    end

    context "when viewing the user's solution" do
      it 'returns false' do
        solution = stub_solution('solution')
        review = build_review(
                   viewed_solution: solution,
                   submitted_solution: solution
                 )

        result = review.viewing_other_solution?

        expect(result).to be_false
      end
    end
  end

  describe '#user_is_awaiting_review?' do
    context "when the user's solution has no comments" do
      it "returns true" do
        solution_with_no_comments =
          stub_solution('no_comments_solution', has_comments?: false)

        review = build_review(submitted_solution: solution_with_no_comments)

        expect(review.user_is_awaiting_review?).to be_true
      end
    end

    context "when the user's solution has comments" do
      it "returns false" do
        solution_with_comments =
          stub_solution('solution_with_comments', has_comments?: true)

        review = build_review(submitted_solution: solution_with_comments)

        expect(review.user_is_awaiting_review?).to be_false
      end
    end
  end

  describe '#user_has_reviewed_other_solution?' do
    context 'when the user has commented on another solution' do
      it 'returns true' do
        user = double('user')
        exercise = double('exercise')
        exercise.stub(:has_comments_from?).with(user).and_return(true)

        review = build_review(
                   reviewer: user,
                   exercise: exercise,
                 )

        expect(review.user_has_reviewed_other_solution?).to be_true
      end
    end

    context 'when the user has not commend on another solution' do
      it 'returns false' do
        user = double('user')
        exercise = double('exercise')
        exercise.stub(:has_comments_from?).with(user).and_return(false)

        review = build_review(
                   reviewer: user,
                   exercise: exercise,
                 )

        expect(review.user_has_reviewed_other_solution?).to be_false
      end
    end
  end

  describe '#user_has_given_and_received_review?' do
    context 'when the user has given and received a review' do
      it 'returns true' do
        user = double('user')
        submitted_solution = stub_solution('submitted_solution', user: user)
        submitted_solution.stub(:has_comments?).and_return(true)
        exercise = double('exercise')
        exercise.stub(:has_comments_from?).with(user).and_return(true)

        review = build_review(
                   submitted_solution: submitted_solution,
                   reviewer: user,
                   exercise: exercise,
                 )

        expect(review.user_has_given_and_received_review?).to be_true
      end
    end

    context 'when the user has not given a review' do
      it 'returns false' do
        user = double('user')
        submitted_solution = stub_solution('submitted_solution', user: user)
        submitted_solution.stub(:has_comments?).and_return(true)
        exercise = double('exercise')
        exercise.stub(:has_comments_from?).with(user).and_return(false)

        review = build_review(
                   submitted_solution: submitted_solution,
                   reviewer: user,
                   exercise: exercise,
                 )

        expect(review.user_has_given_and_received_review?).to be_false
      end
    end

    context 'when the user has not receieved a review' do
      it 'returns false' do
        user = double('user')
        submitted_solution = stub_solution('submitted_solution', user: user)
        submitted_solution.stub(:has_comments?).and_return(false)
        exercise = double('exercise')
        exercise.stub(:has_comments_from?).with(user).and_return(false)

        review =
          build_review(
            submitted_solution: submitted_solution,
            reviewer: user,
            exercise: exercise,
          )

        expect(review.user_has_given_and_received_review?).to be_false
      end
    end
  end

  def build_review(
    comment_locator: double('comment_locator'),
    submitted_solution: stub_solution('submitted_solution'),
    other_solutions: [stub_solution('other_solution')],
    viewed_solution: submitted_solution || other_solutions.first,
    exercise: double('exercise'),
    status_factory: double('status_factory'),
    reviewer: double('user')
  )
    solutions = [submitted_solution, *other_solutions].compact
    Review.new(
      comment_locator: comment_locator,
      exercise: exercise,
      solutions: solutions,
      submitted_solution: submitted_solution,
      viewed_solution: viewed_solution,
      status_factory: status_factory,
      reviewer: reviewer,
    )
  end

  def stub_solution(name, attributes = {})
    double(name, attributes.merge(name: name)).tap do |solution|
      solution.stub(:id).and_return(solution.object_id)
    end
  end
end
