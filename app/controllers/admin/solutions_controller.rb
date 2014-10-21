class Admin::SolutionsController < Admin::BaseController
  def index
    @solutions = dependencies[:latest_solutions]
  end
end
