class Admin::SolutionsController < Admin::BaseController
  def index
    @solutions = dependencies[:prioritized_solutions_factory].new
  end
end
