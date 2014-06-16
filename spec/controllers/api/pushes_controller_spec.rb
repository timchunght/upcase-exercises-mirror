require 'spec_helper'

describe Api::PushesController do
  describe '#create' do
    context 'with an unknown solution' do
      it 'returns an empty 404' do
        participation = double('participation')
        participation.
          stub(:push_to_clone).
          and_raise(ActiveRecord::RecordNotFound)

        push_solution_for participation

        expect(controller).to respond_with(404)
        expect(response.body.strip).to be_empty
      end
    end

    context 'with an existing solution' do
      it 'triggers an update without authentication' do
        participation = double('participation')
        participation.stub(:push_to_clone)

        push_solution_for participation

        expect(controller).to respond_with(201)
        expect(participation).to have_received(:push_to_clone)
      end
    end
  end

  def push_solution_for(participation)
    exercise = build_stubbed(:exercise)
    Exercise.stub(:find).with(exercise.to_param).and_return(exercise)
    user = build_stubbed(:user)
    User.stub(:find).with(user.to_param).and_return(user)
    factory = stub_factory(:participation)
    factory.
      stub(:new).
      with(exercise: exercise, user: user).
      and_return(participation)
    post :create, exercise_id: exercise.to_param, user_id: user.to_param
  end
end
