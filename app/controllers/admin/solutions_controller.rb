class Admin::SolutionsController < Admin::BaseController
  def index
    @solutions = dependencies[:reviewable_solutions_factory].new
  end
end
