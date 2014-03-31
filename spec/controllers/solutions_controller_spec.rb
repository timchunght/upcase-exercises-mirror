require 'spec_helper'

describe SolutionsController do
  describe '#show' do
    context 'as a user with a solution' do
      it 'renders the solution' do
        with_viewable_solution do |exercise, user|
          current_user = build_stubbed(:user)
          exercise.stub(:solved_by?).with(current_user).and_return(true)
          sign_in_as current_user

          show(exercise, user)

          should respond_with(:success)
        end
      end
    end

    context 'as a user without a solution' do
      it 'redirects to the exercise' do
        with_viewable_solution do |exercise, user|
          current_user = build_stubbed(:user)
          exercise.stub(:solved_by?).with(current_user).and_return(false)
          sign_in_as current_user

          show(exercise, user)

          should redirect_to(exercise_url(exercise))
        end
      end
    end
  end

  def with_viewable_solution
    exercise = build_stubbed(:exercise)
    Exercise.stub(:find).with(exercise.to_param).and_return(exercise)
    user = build_stubbed(:user)
    User.stub(:find).with(user.to_param).and_return(user)
    solution = build_stubbed(:solution)
    exercise.stub(:find_solution_for).with(user).and_return(solution)
    yield exercise, user
  end

  def show(exercise, user)
    get :show, exercise_id: exercise.to_param, id: user.to_param
  end
end
