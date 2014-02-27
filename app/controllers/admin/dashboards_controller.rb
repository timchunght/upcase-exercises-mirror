class Admin::DashboardsController < Admin::BaseController
  def show
    redirect_to admin_exercises_path
  end
end
