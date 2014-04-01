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
      dependencies[:git_server].create_exercise(
        dependencies[:git_server].source(@exercise)
      )
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
    GitExercise.new(Exercise.find(params[:id]), dependencies[:git_server])
  end
end
