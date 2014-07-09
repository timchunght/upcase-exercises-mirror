class PushesController < ApplicationController
  def show
    @overview = dependencies[:current_overview]
    render layout: false
  end
end
