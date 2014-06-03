class CommentsController < ApplicationController
  layout false

  def new
    @comment = solution.comments.new(new_params)
  end

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
    params.require(:comment).permit(:text, :location).merge(user: current_user)
  end

  def new_params
    params.permit(:solution_id, :location)
  end
end
