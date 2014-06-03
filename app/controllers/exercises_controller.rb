class ExercisesController < ApplicationController
  def show
    @overview = dependencies[:current_overview]
  end
end
