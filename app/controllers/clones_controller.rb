class ClonesController < ApplicationController
  def create
    clone = dependencies[:current_participation].find_or_create_clone
    redirect_to clone.exercise
  end
end
