class InlineCommentsController < ApplicationController
  def new
    @solution = Solution.find(new_params[:solution_id])
    @comment = InlineComment.new(new_params.slice(:file_name, :line_number))
    render layout: false
  end

  def create
    @comment = create_comment
    render layout: false
  end

  private

  def create_comment
    latest_revision.inline_comments.create!(comment_params)
  end

  def solution
    Solution.find(params[:solution_id])
  end

  def latest_revision
    solution.latest_revision
  end

  def comment_params
    params.require(:inline_comment).
      permit(:text, :file_name, :line_number).
      merge(user: current_user)
  end

  def new_params
    params.permit(:solution_id, :file_name, :line_number)
  end
end
