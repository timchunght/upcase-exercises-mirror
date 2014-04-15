class CommentsController < ApplicationController
  def create
    @comment = solution.comments.create!(comment_params)
  end

  private

  def solution
    Solution.find(params[:solution_id])
  end

  def comment_params
    params.require(:comment).permit(:text).merge(user: current_user)
  end
end
