require 'spec_helper'

describe Api::PushesController do
  describe '#create' do
    it 'triggers an update without authentication' do
      exercise = build_stubbed(:exercise)
      Exercise.stub(:find).with(exercise.to_param).and_return(exercise)
      user = build_stubbed(:user)
      User.stub(:find).with(user.to_param).and_return(user)
      participation =
        stub_factory_instance(:participation, exercise: exercise, user: user)
      participation.stub(:update_solution)

      post :create, exercise_id: exercise.to_param, user_id: user.to_param

      expect(controller).to respond_with(201)
      expect(participation).to have_received(:update_solution)
    end
  end
end
