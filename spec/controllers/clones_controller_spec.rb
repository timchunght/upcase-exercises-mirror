require 'spec_helper'

describe ClonesController do
  describe '#create' do
    it 'creates a new clone for the user' do
      user = build_stubbed(:user)
      exercise = build_stubbed(:exercise)
      Exercise.stub(:find).with(exercise.to_param).and_return(exercise)
      clone = build_stubbed(:clone)
      exercise.stub(:find_or_create_clone_for).with(user).and_return(clone)

      sign_in_as user
      post :create, exercise_id: exercise.to_param

      should redirect_to(exercise_clone_url(exercise))
    end
  end
end
