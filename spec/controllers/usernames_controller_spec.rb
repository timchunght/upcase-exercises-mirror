require 'spec_helper'

describe UsernamesController do
  describe '#update' do
    context 'with valid parameters' do
      it 'redirects back' do
        user_params = { 'username' => 'username' }
        user = build_stubbed(:user)
        user.stub(:update_attributes).with(user_params).and_return(true)
        referer = '/some/path'

        sign_in_as user
        request.env['HTTP_REFERER'] = referer
        put :update, user: user_params, format: :js

        expect(controller).to redirect_to(referer)
      end
    end

    context 'with invalid parameters' do
      it 're-renders the form' do
        user = build_stubbed(:user)
        user.stub(:update_attributes).and_return(false)

        sign_in_as user
        put :update, user: { username: '' }, format: :js

        expect(controller).to render_template(:update)
        expect(controller).not_to render_with_layout
      end
    end
  end
end
