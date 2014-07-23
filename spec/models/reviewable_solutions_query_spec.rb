require "spec_helper"

describe ReviewableSolutionsQuery do
  describe "#submitted_solution" do
    it "returns the submitted solution" do
      submitted_solution = double(:submitted_solution)
      reviewable_solutions = build_reviewable_solutions(
        submitted_solution: submitted_solution,
        viewed_solution: submitted_solution,
      )

      result = reviewable_solutions.submitted_solution

      expect(result).to eq(submitted_solution)
    end
  end

  describe "#assigned_solution" do
    it "returns the first assigned solution by another user" do
      submitted_solution = double("submitted")
      assigned_solution = double("first_other")
      solutions = [
        submitted_solution,
        assigned_solution,
        double("second_other")
      ]
      reviewable_solutions = build_reviewable_solutions(
        submitted_solution: submitted_solution,
        solutions: solutions
      )

      expect(reviewable_solutions.assigned_solution).to eq(assigned_solution)
    end

    it "assigns the submitted solution without another solution" do
      submitted_solution = double("submitted_solution")
      reviewable_solutions = build_reviewable_solutions(
        submitted_solution: submitted_solution,
        solutions: [submitted_solution]
      )

      expect(reviewable_solutions.assigned_solution).to eq submitted_solution
    end
  end

  describe "#solutions_by_other_users" do
    it "returns solutions besides the submitted solution" do
      submitted_solution = double("submitted_solution")
      viewed_solution = double("viewed_solution")
      other_solution = double("other_solution")
      prioritized_solutions = double(
        "prioritized_solutions",
        to_a: [other_solution, viewed_solution, submitted_solution]
      )
      solutions = build_reviewable_solutions(
        solutions: prioritized_solutions,
        submitted_solution: submitted_solution,
        viewed_solution: viewed_solution
      )

      result = solutions.solutions_by_other_users

      expect(result).to eq([other_solution, viewed_solution])
    end
  end

  describe "#assigned_solver" do
    it "returns the solver for the assigned solution" do
      user = double("user")
      assigned_solution = double("assigned_solution", user: user)
      solutions = build_reviewable_solutions(solutions: [assigned_solution])

      result = solutions.assigned_solver

      expect(result).to eq(user)
    end
  end

  describe "#assigned_solver_username" do
    it "returns the solver username for the assigned solution" do
      username = double("username")
      assigned_solution = double("assigned_solution", username: username)
      solutions = build_reviewable_solutions(solutions: [assigned_solution])

      result = solutions.assigned_solver_username

      expect(result).to eq(username)
    end
  end

  def build_reviewable_solutions(
    solutions: double(:solutions),
    submitted_solution: double(:submitted_solution),
    viewed_solution: double(:viewed_solution)
  )
    ReviewableSolutionsQuery.new(
      solutions: solutions,
      submitted_solution: submitted_solution,
      viewed_solution: viewed_solution,
    )
  end
end
