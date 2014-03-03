class DashboardsController < ApplicationController
  def show
    redirect_to URI.join(LEARN_URL, 'dashboard').to_s
  end
end
