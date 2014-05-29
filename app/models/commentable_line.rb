class CommentableLine < SimpleDelegator
  def initialize(diff_line, comment_finder, solution)
    @solution = solution
    @comment_finder = comment_finder
    @url_helper = UrlHelper.new
    super(diff_line)
  end

  def comments
    @comment_finder.comments_for(file_name, number)
  end

  def new_comment_path
    @url_helper.new_solution_inline_comment_path(
      @solution,
      file_name: file_name,
      line_number: number
    )
  end

  private

  class UrlHelper
    include Rails.application.routes.url_helpers
  end
end
