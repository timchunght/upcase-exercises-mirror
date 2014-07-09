require 'spec_helper'

describe SolutionsController do
  describe '#show' do
    context 'as a subscriber with a solution' do
      it 'renders the solution' do
        view_solution_with_submission as: :subscriber

        should respond_with(:success)
      end
    end

    context 'as a subscriber without a solution' do
      it 'redirects to the exercise' do
        exercise = view_solution_without_submission(as: :subscriber)

        should redirect_to(exercise_url(exercise))
      end
    end

    context 'as an admin without a solution' do
      it 'renders the solution' do
        view_solution_without_submission as: :admin

        should respond_with(:success)
      end
    end
  end

  def view_solution_with_submission(arguments)
    exercise = build_stubbed(:exercise)
    role = arguments.fetch(:as)
    participation = sign_in_as_user_with_submission_to(exercise, role)
    submitted_solution = participation.find_solution
    view_solution_to exercise, submitted_solution
  end

  def view_solution_without_submission(arguments)
    build_stubbed(:exercise).tap do |exercise|
      sign_in_as_user_without_submission_to(exercise, arguments.fetch(:as))
      view_solution_to exercise, nil
    end
  end

  def view_solution_to(exercise, submitted_solution)
    Exercise.stub(:find).with(exercise.to_param).and_return(exercise)
    user = build_stubbed(:user)
    User.stub(:find).with(user.to_param).and_return(user)
    viewed_solution = build_stubbed(:solution)
    participation =
      stub_factory_instance(:participation, exercise: exercise, user: user)
    participation.stub(:find_solution).and_return(viewed_solution)
    review = stub_factory_instance(
      :review,
      exercise: exercise,
      submitted_solution: submitted_solution,
      viewed_solution: viewed_solution,
      reviewer: an_instance_of(User),
    )
    review.stub(:comments).and_return([])
    CommentLocator.stub(:new).and_return(double('comment_locator'))

    show(exercise, user)
  end

  def sign_in_as_user_with_submission_to(exercise, user_type)
    sign_in_as_user_with_participation_to(exercise, user_type)
      .tap do |participation|
        participation.stub(:find_solution).and_return(double('solution'))
        participation.stub(:has_solution?).and_return(true)
      end
  end

  def sign_in_as_user_without_submission_to(exercise, user_type)
    sign_in_as_user_with_participation_to(exercise, user_type)
      .tap do |participation|
        participation.stub(:find_solution).and_raise
        participation.stub(:has_solution?).and_return(false)
      end
  end

  def sign_in_as_user_with_participation_to(exercise, user_type)
    user = build_stubbed(user_type)
    sign_in_as user
    stub_factory_instance(:participation, exercise: exercise, user: user)
  end

  def show(exercise, user)
    get :show, exercise_id: exercise.to_param, id: user.to_param
  end
end
