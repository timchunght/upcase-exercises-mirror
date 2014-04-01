require 'spec_helper'

describe SolutionsController do
  describe '#show' do
    context 'as a user with a solution' do
      it 'renders the solution' do
        with_viewable_solution do |exercise, user|
          participation = sign_in_as_user_with_participation_to(exercise)
          participation.stub(:has_solution?).and_return(true)

          show(exercise, user)

          should respond_with(:success)
        end
      end
    end

    context 'as a user without a solution' do
      it 'redirects to the exercise' do
        with_viewable_solution do |exercise, user|
          participation = sign_in_as_user_with_participation_to(exercise)
          participation.stub(:has_solution?).and_return(false)

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
    participation =
      stub_factory_instance(:participation, exercise: exercise, user: user)
    participation.stub(:find_solution).and_return(solution)
    yield exercise, user
  end

  def sign_in_as_user_with_participation_to(exercise)
    solution = double('solution')
    user = build_stubbed(:user)
    sign_in_as user
    stub_factory_instance(:participation, exercise: exercise, user: user)
      .tap do |participation|
        participation.stub(:find_solution).and_return(solution)
      end
  end

  def show(exercise, user)
    get :show, exercise_id: exercise.to_param, id: user.to_param
  end
end
