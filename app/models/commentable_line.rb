class CommentableLine < SimpleDelegator
  def initialize(diff_line, comment_locator, solution)
    @solution = solution
    @comment_locator = comment_locator
    @url_helper = UrlHelper.new
    super(diff_line)
  end

  def comments
    @comment_locator.inline_comments_for(file_name, number)
  end

  def new_comment_path
    @url_helper.new_solution_comment_path(
      @solution,
      location: @comment_locator.location_for(file_name, number)
    )
  end

  private

  class UrlHelper
    include Rails.application.routes.url_helpers
  end
end
