require 'spec_helper'

describe ClonesController do
  describe '#create' do
    context 'for a user with a username' do
      it 'creates a new clone for the user' do
        exercise = build_stubbed(:exercise)
        participation = stub_service(:current_participation)
        participation.stub(:create_clone)
        user = build_stubbed(:user, username: 'hello')

        sign_in_as user
        post :create, exercise_id: exercise.to_param

        expect(controller).not_to render_with_layout
        expect(participation).to have_received(:create_clone)
      end
    end

    context 'for a user without a username' do
      it 'prompts for a username' do
        exercise = build_stubbed(:exercise)
        participation = stub_service(:current_participation)
        participation.stub(:create_clone)
        user = build_stubbed(:user, username: '')

        sign_in_as user
        post :create, exercise_id: exercise.to_param

        expect(controller).to render_template(partial: 'usernames/_edit')
        expect(participation).not_to have_received(:create_clone)
      end
    end
  end

  describe '#show' do
    context 'with an existing clone' do
      it 'renders success' do
        show_overview has_clone?: true

        expect(controller).to respond_with(:success)
      end
    end

    context 'without a clone' do
      it 'renders not found' do
        show_overview has_clone?: false

        expect(controller).to respond_with(:not_found)
      end
    end

    def show_overview(stubs)
      exercise = build_stubbed(:exercise)
      overview = stub_service(:current_overview)
      overview.stub(stubs)

      sign_in
      get :show, exercise_id: exercise.to_param
    end
  end
end
