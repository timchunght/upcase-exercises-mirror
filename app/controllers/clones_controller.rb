class ClonesController < ApplicationController
  layout false

  def create
    dependencies[:current_participation].create_clone
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
