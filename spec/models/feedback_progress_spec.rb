require "spec_helper"

describe FeedbackProgress do
  describe "#user_is_awaiting_review?" do
    context "when the user has submitted a solution" do
      context "and the user's solution has no comments" do
        it "returns true" do
          progress =
            build_progress(submitted_solution: stub_solution_without_comments)

          expect(progress.user_is_awaiting_review?).to be_true
        end
      end

      context "and the user's solution has comments" do
        it "returns false" do
          progress =
            build_progress(submitted_solution: stub_solution_with_comments)

          expect(progress.user_is_awaiting_review?).to be_false
        end
      end
    end

    context "when the user has not submitted a solution" do
      it "returns false" do
        progress = build_progress(submitted_solution: nil)

        expect(progress.user_is_awaiting_review?).to be_false
      end
    end
  end

  describe "#user_has_reviewed_other_solution?" do
    context "when the user has commented on another solution" do
      it "returns true" do
        user = double("user")
        exercise = stub_exercise_with_comments_from(user)

        progress = build_progress(reviewer: user, exercise: exercise)

        expect(progress.user_has_reviewed_other_solution?).to be_true
      end
    end

    context "when the user has not commend on another solution" do
      it "returns false" do
        user = double("user")
        exercise = stub_exercise_without_comments

        progress = build_progress(
          reviewer: user,
          exercise: exercise,
        )

        expect(progress.user_has_reviewed_other_solution?).to be_false
      end
    end
  end

  describe "#user_has_given_and_received_review?" do
    context "when the user has given and received a review" do
      it "returns true" do
        user = double("user")
        submitted_solution = stub_solution_with_comments
        exercise = stub_exercise_with_comments_from(user)

        progress = build_progress(
          exercise: exercise,
          reviewer: user,
          submitted_solution: submitted_solution,
        )

        expect(progress.user_has_given_and_received_review?).to be_true
      end
    end

    context "when the user has not given a review" do
      it "returns false" do
        user = double("user")
        submitted_solution = stub_solution_with_comments
        exercise = stub_exercise_without_comments

        progress = build_progress(
          exercise: exercise,
          reviewer: user,
          submitted_solution: submitted_solution,
        )

        expect(progress.user_has_given_and_received_review?).to be_false
      end
    end

    context "when the user has not receieved a review" do
      it "returns false" do
        user = double("user")
        submitted_solution = stub_solution_without_comments
        exercise = stub_exercise_without_comments

        progress = build_progress(
          exercise: exercise,
          reviewer: user,
          submitted_solution: submitted_solution,
        )

        expect(progress.user_has_given_and_received_review?).to be_false
      end
    end

    context "when the user has not submitted a solution" do
      it "returns false" do
        user = double("user")
        exercise = stub_exercise_without_comments

        progress = build_progress(
            submitted_solution: nil,
            reviewer: user,
            exercise: exercise,
          )

        expect(progress.user_has_given_and_received_review?).to be_false
      end
    end
  end

  def stub_exercise_with_comments_from(user)
    double("exercise").tap do |exercise|
      exercise.stub(:has_comments_from?).with(user).and_return(true)
    end
  end

  def stub_exercise_without_comments
    double("exercise", has_comments_from?: false)
  end

  def stub_solution_with_comments
    double("solution_with_comments", has_comments?: true)
  end

  def stub_solution_without_comments
    double("no_comments_solution", has_comments?: false)
  end

  def build_progress(
    submitted_solution: double("submitted_solution"),
    exercise: double("exercise"),
    reviewer: double("user")
  )
    FeedbackProgress.new(
      submitted_solution: submitted_solution,
      exercise: exercise,
      reviewer: reviewer
    )
  end
end
