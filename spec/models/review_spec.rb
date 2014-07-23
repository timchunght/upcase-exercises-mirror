require "spec_helper"

describe Review do
  describe "#exercise" do
    it "returns its exercise" do
      exercise = double("exercise")
      review = build_review(exercise: exercise)

      result = review.exercise

      expect(result).to eq(exercise)
    end
  end

  describe "#status" do
    it "build status from its factory" do
      status_factory = double("status_factory")
      status = double("status")
      status_factory.stub(:new).and_return(status)
      review = build_review(status_factory: status_factory)

      result = review.status

      expect(result).to eq(status)
    end
  end

  describe "#viewed_solution" do
    it "returns its viewed solution" do
      viewed_solution = double("viewed_solution")
      review = build_review(viewed_solution: viewed_solution)

      expect(review.viewed_solution).to eq(viewed_solution)
    end
  end

  describe "#solutions_by_other_users" do
    it "delegates to its solutions" do
      solutions_by_other_users = double("solutions_by_other_users")
      solutions =
        double("solutions", solutions_by_other_users: solutions_by_other_users)
      review = build_review(solutions: solutions)

      result = review.solutions_by_other_users

      expect(result).to eq(solutions_by_other_users)
    end
  end

  describe "#assigned_solver_username" do
    it "returns the username of the first solver besides the reviewer" do
      username = double("username")
      solutions = double("solutions", assigned_solver_username: username)
      review = build_review(solutions: solutions)

      expect(review.assigned_solver_username).to eq(username)
    end
  end

  describe "#assigned_solver" do
    it "returns the submitter of the assigned solution" do
      solver = double("solver")
      solutions = double("solutions", assigned_solver: solver)
      review = build_review(solutions: solutions)

      expect(review.assigned_solver).to eq(solver)
    end
  end

  describe "#submitted_solution" do
    it "delegates to solutions" do
      submitted_solution = double("submitted_solution")
      solutions = double("solutions", submitted_solution: submitted_solution)
      review = build_review(solutions: solutions)

      result = review.submitted_solution

      expect(result).to eq(submitted_solution)
    end
  end

  describe "#viewing_other_solution?" do
    context "when viewing a solution other than the user's" do
      it "returns true" do
        submitted_solution = stub_solution("submitted_solution")
        viewed_solution = stub_solution("viewed_solution")
        review = build_review(
                   viewed_solution: viewed_solution,
                   submitted_solution: submitted_solution
                 )

        result = review.viewing_other_solution?

        expect(result).to be_true
      end
    end

    context "when viewing the user's solution" do
      it "returns false" do
        solution = stub_solution("solution")
        review = build_review(
                   viewed_solution: solution,
                   submitted_solution: solution
                 )

        result = review.viewing_other_solution?

        expect(result).to be_false
      end
    end
  end

  describe "#user_is_awaiting_review?" do
    context "when the user has submitted a solution" do
      context "and the user's solution has no comments" do
        it "returns true" do
          solution_with_no_comments =
            stub_solution("no_comments_solution", has_comments?: false)

          review = build_review(submitted_solution: solution_with_no_comments)

          expect(review.user_is_awaiting_review?).to be_true
        end
      end

      context "and the user's solution has comments" do
        it "returns false" do
          solution_with_comments =
            stub_solution("solution_with_comments", has_comments?: true)

          review = build_review(submitted_solution: solution_with_comments)

          expect(review.user_is_awaiting_review?).to be_false
        end
      end
    end

    context "when the user has not submitted a solution" do
      it "returns false" do
        review = build_review(submitted_solution: nil)

        expect(review.user_is_awaiting_review?).to be_false
      end
    end
  end

  describe "#user_has_reviewed_other_solution?" do
    context "when the user has commented on another solution" do
      it "returns true" do
        user = double("user")
        exercise = double("exercise")
        exercise.stub(:has_comments_from?).with(user).and_return(true)

        review = build_review(
                   reviewer: user,
                   exercise: exercise,
                 )

        expect(review.user_has_reviewed_other_solution?).to be_true
      end
    end

    context "when the user has not commend on another solution" do
      it "returns false" do
        user = double("user")
        exercise = double("exercise")
        exercise.stub(:has_comments_from?).with(user).and_return(false)

        review = build_review(
                   reviewer: user,
                   exercise: exercise,
                 )

        expect(review.user_has_reviewed_other_solution?).to be_false
      end
    end
  end

  describe "#user_has_given_and_received_review?" do
    context "when the user has given and received a review" do
      it "returns true" do
        user = double("user")
        submitted_solution = stub_solution("submitted_solution", user: user)
        submitted_solution.stub(:has_comments?).and_return(true)
        exercise = double("exercise")
        exercise.stub(:has_comments_from?).with(user).and_return(true)

        review = build_review(
                   submitted_solution: submitted_solution,
                   reviewer: user,
                   exercise: exercise,
                 )

        expect(review.user_has_given_and_received_review?).to be_true
      end
    end

    context "when the user has not given a review" do
      it "returns false" do
        user = double("user")
        submitted_solution = stub_solution("submitted_solution", user: user)
        submitted_solution.stub(:has_comments?).and_return(true)
        exercise = double("exercise")
        exercise.stub(:has_comments_from?).with(user).and_return(false)

        review = build_review(
                   submitted_solution: submitted_solution,
                   reviewer: user,
                   exercise: exercise,
                 )

        expect(review.user_has_given_and_received_review?).to be_false
      end
    end

    context "when the user has not receieved a review" do
      it "returns false" do
        user = double("user")
        submitted_solution = stub_solution("submitted_solution", user: user)
        submitted_solution.stub(:has_comments?).and_return(false)
        exercise = double("exercise")
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

    context "when the user has not submitted a solution" do
      it "returns false" do
        user = double("user")
        exercise = double("exercise")
        exercise.stub(:has_comments_from?).with(user).and_return(true)

        review =
          build_review(
            submitted_solution: nil,
            reviewer: user,
            exercise: exercise,
          )

        expect(review.user_has_given_and_received_review?).to be_false
      end
    end
  end

  describe "#user_has_solution?" do
    context "with a submitted solution" do
      it "returns true" do
        review = build_review(submitted_solution: double("submitted_solution"))

        expect(review.user_has_solution?).to be_true
      end
    end

    context "without a submitted solution" do
      it "returns false" do
        review = build_review(submitted_solution: nil)

        expect(review.user_has_solution?).to be_false
      end
    end
  end

  def build_review(
    submitted_solution: stub_solution("submitted_solution"),
    other_solutions: [stub_solution("other_solution")],
    viewed_solution: submitted_solution || other_solutions.first,
    exercise: double("exercise"),
    feedback: double("feedback"),
    status_factory: double("status_factory"),
    reviewer: double("user"),
    solutions: double(
      "solutions",
      solutions_by_other_users: other_solutions,
      submitted_solution: submitted_solution
    )
  )
    Review.new(
      exercise: exercise,
      feedback: feedback,
      solutions: solutions,
      viewed_solution: viewed_solution,
      status_factory: status_factory,
      reviewer: reviewer
    )
  end

  def stub_solution(name, attributes = {})
    double(name, attributes.merge(name: name)).tap do |solution|
      solution.stub(:id).and_return(solution.object_id)
    end
  end
end
