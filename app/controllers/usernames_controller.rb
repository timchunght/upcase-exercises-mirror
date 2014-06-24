class UsernamesController < ApplicationController
  def update
    if current_user.update_attributes(user_attributes)
      redirect_to :back
    else
      render
    end
  end

  private

  def user_attributes
    params.require(:user).permit(:username)
  end
end
