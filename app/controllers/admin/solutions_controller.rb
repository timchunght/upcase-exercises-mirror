class Admin::SolutionsController < Admin::BaseController
  def index
    @solutions = dependencies[:reviewable_solutions].new
  end
end
