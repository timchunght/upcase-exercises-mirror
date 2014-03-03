require 'spec_helper'

describe DashboardsController do
  describe '#show' do
    it 'redirects to the Learn dashboard' do
      stub_const 'LEARN_URL', 'http://learn.example.com'

      sign_in
      get :show

      should redirect_to('http://learn.example.com/dashboard')
    end
  end
end
