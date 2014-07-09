require "spec_helper"

describe RevisionsController do
  describe "#show" do
    context "as a subscriber with a solution" do
      it "renders the revision" do
        user = build_stubbed(:user)
        visit_revision_as(user, owner: user)

        expect(response).to render_template("revisions/show")
      end
    end

    context "as an admin without a solution" do
      it "renders the revision" do
        admin = build_stubbed(:admin)
        revision_owner = build_stubbed(:user)
        visit_revision_as(admin, owner: revision_owner)

        expect(response).to render_template("revisions/show")
      end
    end

    context "as a subscriber without a solution" do
      it "redirects to the exercise" do
        user = build_stubbed(:user)
        exercise = build_stubbed(:exercise)
        visit_revision_as(user, exercise: exercise)

        expect(response).to redirect_to(exercise_path(exercise))
      end
    end
  end

  def visit_revision_as(visitor,
                        owner: build_stubbed(:user),
                        exercise: build_stubbed(:exercise))
    sign_in_as visitor

    is_owner = (visitor == owner)

    allow(Exercise).to receive(:find).and_return(exercise)
    allow(User).to receive(:find).and_return(owner)

    solution = build_stubbed(:solution)
    revision = build_stubbed(:revision)
    allow(Revision).to receive(:find_by_number).and_return(revision)

    visitor_participation = participation_factory(visitor, exercise)
    allow(visitor_participation).to receive(:has_solution?).and_return(is_owner)

    owner_participation = participation_factory(owner, exercise)
    allow(owner_participation).to receive(:has_solution?).and_return(true)
    allow(owner_participation).to receive(:find_solution).and_return(solution)

    submitted_solution = nil
    if is_owner
      submitted_solution = solution
    end

    stub_factory_instance(
      :review_factory,
      exercise: exercise,
      viewed_solution: solution,
      submitted_solution: submitted_solution,
      reviewer: visitor,
      revision: revision
    )

    show(exercise, owner)
  end

  def participation_factory(user, exercise)
    stub_factory_instance(
      :participation_factory,
      exercise: exercise,
      user: user
    )
  end

  def show(exercise, user)
    get :show,
      exercise_id: exercise.to_param,
      solution_id: user.to_param,
      id: 1
  end
end
