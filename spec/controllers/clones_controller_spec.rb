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

      should redirect_to(exercise_clone_url(exercise))
      expect(participation).to have_received(:find_or_create_clone)
    end
  end

  describe '#show' do
    context 'with an existing public key' do
      it 'renders the instructions' do
        show_exercise_with_public_keys [double('public_key')]

        expect(controller).to render_template(:show)
      end
    end

    context 'without any public keys' do
      it 'redirects to the upload key page' do
        show_exercise_with_public_keys []

        expect(controller).to redirect_to(new_gitolite_public_key_url)
        expect(controller).to store_location
      end
    end

    def show_exercise_with_public_keys(public_keys)
      exercise = build_stubbed(:exercise)
      clone = double('clone')
      stub_service(:git_server)
      participation = stub_service(:current_participation)
      participation.stub(:find_clone).and_return(clone)
      user = build_stubbed(:user)
      user.stub(:public_keys).and_return(public_keys)
      sign_in_as user
      get :show, exercise_id: exercise.to_param
    end

    def store_location
      set_session(:return_to).to(request.fullpath)
    end
  end
end
