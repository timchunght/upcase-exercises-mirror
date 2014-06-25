class ClonesController < ApplicationController
  layout false

  def create
    if current_user.username?
      dependencies[:current_participation].create_clone
    else
      render partial: 'usernames/edit', locals: { user: current_user }
    end
  end

  def show
    @overview = dependencies[:current_overview]

    if @overview.has_clone?
      render
    else
      head :not_found
    end
  end
end
