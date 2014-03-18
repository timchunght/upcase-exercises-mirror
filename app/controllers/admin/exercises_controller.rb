class Admin::ExercisesController < Admin::BaseController
  layout 'admin'

  def index
    @exercises = Exercise.all
  end

  def new
    @exercise = Exercise.new
  end

  def create
    @exercise = Exercise.new(exercise_params)
    if @exercise.save
      GIT_SERVER.create_exercise(GIT_SERVER.source(@exercise))
      redirect_to admin_exercises_path
    else
      render :new
    end
  end

  def edit
    @exercise = find_exercise
  end

  def update
    @exercise = find_exercise
    if @exercise.update_attributes(exercise_params)
      redirect_to admin_exercises_path, notice: t('.notice')
    else
      render :edit
    end
  end

  private

  def exercise_params
    params.require(:exercise).permit(:title, :body)
  end

  def find_exercise
    Exercise.find(params[:id])
  end
end
