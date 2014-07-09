require "spec_helper"

describe "revisions/show.html.haml" do
  it "does not allow inline comments on old revisions" do
    assign(:review, review_factory)
    allow(view).to receive(:current_user).and_return(double(:user))

    render

    expect(rendered).not_to match(/\[data\-role\=\'make\-comment\'\]/)
  end

  def review_factory
    solution = build_stubbed(:solution)
    allow(solution).to receive(:assigned?).and_return(double(:user))
    allow(solution).to receive(:active?).and_return(true)

    revision = build_stubbed(:revision)
    allow(revision).to receive(:user).and_return(build_stubbed(:user))
    allow(revision).to receive(:exercise).and_return(build_stubbed(:exercise))
    allow(revision).to receive(:number).and_return(1)
    double(
      :review,
      submitted?: true,
      my_solution: solution,
      viewed_solution: solution,
      status: "solutions/progress_bar",
      revisions: [revision],
      revision: revision,
      has_solutions_by_other_users?: false,
      files: [],
      top_level_comments: [],
      latest_revision?: false
    )
  end
end
