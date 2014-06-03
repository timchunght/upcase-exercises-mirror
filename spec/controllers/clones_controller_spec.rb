require 'spec_helper'

describe ClonesController do
  describe '#create' do
    it 'creates a new clone for the user' do
      exercise = build_stubbed(:exercise)
      clone = double('clone', exercise: exercise)
      participation = stub_service(:current_participation)
      participation.stub(:find_or_create_clone).and_return(clone)

      sign_in
      post :create, exercise_id: exercise.to_param

      should redirect_to(exercise_url(exercise))
      expect(participation).to have_received(:find_or_create_clone)
    end
  end
end
