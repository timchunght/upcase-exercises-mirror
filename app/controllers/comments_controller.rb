class CommentsController < ApplicationController
  def create
    @comment = create_comment
    send_notification
  end

  private

  def create_comment
    solution.comments.create!(comment_params)
  end

  def send_notification
    dependencies[:comment_notification].new(comment: @comment).deliver
  end

  def solution
    Solution.find(params[:solution_id])
  end

  def comment_params
    params.require(:comment).permit(:text).merge(user: current_user)
  end
end
