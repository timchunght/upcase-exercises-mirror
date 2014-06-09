require 'spec_helper'

describe ExercisesController do
  describe '#show' do
    it 'tracks when a user views an exercise' do
      exercise = build_stubbed(:exercise)
      user = build_stubbed(:user)
      stub_service(:current_overview)
      tracker = stub_factory_instance(:event_tracker, user: user)
      tracker.stub(:track_exercise_visit)
      sign_in_as user

      get :show, id: exercise.to_param

      expect(tracker).to have_received(:track_exercise_visit)
    end
  end
end
