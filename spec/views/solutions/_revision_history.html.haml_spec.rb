require "spec_helper"

describe "solutions/_revision_history.html.haml" do
  it "contains a link to the current version of the solution" do
    solution = build_stubbed(:solution)
    user = build_stubbed(:user)
    exercise = build_stubbed(:exercise)
    revision = double(
      :revision,
      id: 1,
      exercise: exercise,
      user: user,
      number: 1,
      latest?: true,
      created_at: Time.now
    )
    review = double(
      :review,
      viewed_solution: solution,
      revision: revision,
      revisions: [revision]
    )
    solution_link = exercise_solution_path(exercise, user)

    render_revision_history_with(review)

    expect(rendered).to match(solution_link)
  end

  def render_revision_history_with(review)
    render("solutions/revision_history", review: review)
  end
end
