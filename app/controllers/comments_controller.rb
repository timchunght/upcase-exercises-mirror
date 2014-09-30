class CommentsController < ApplicationController
  layout false

  def new
    @comment = solution.comments.new(new_params)
  end

  def create
    @comment = create_comment
    send_notification
    track_comment_creation
  end

  private

  def create_comment
    solution.comments.create!(comment_params)
  end

  def send_notification
    dependencies[:comment_notification_factory].new(comment: @comment).deliver
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

  def track_comment_creation
    event_tracker.comment_created(solution)
    status_updater.comment_created
  end

  def status_updater
    dependencies[:status_updater_factory].new(
      user: current_user,
      exercise: solution.exercise
    )
  end

  def event_tracker
    dependencies[:event_tracker_factory].new(
      user: current_user,
      exercise: solution.exercise
    )
  end
end
