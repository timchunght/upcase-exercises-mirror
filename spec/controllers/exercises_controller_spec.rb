require 'spec_helper'

describe ExercisesController do
  describe '#show' do
    it 'tracks when a user views an exercise' do
      exercise = build_stubbed(:exercise)
      user = build_stubbed(:user)
      stub_service(:current_overview)
      tracker = stub_factory_instance(:event_tracker_factory, user: user)
      tracker.stub(:exercise_visited)
      sign_in_as user

      get :show, id: exercise.to_param

      expect(tracker).to have_received(:exercise_visited)
    end
  end
end
