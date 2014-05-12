require 'spec_helper'

describe 'comments/_comment.html' do
  it "renders the user's avatar" do
    user = build_stubbed(:user, username: 'example_user')
    comment = build_stubbed(:comment, user: user)
    stub_template '_avatar.html.haml' => 'rendered avatar'

    render comment

    expect(rendered).to include('rendered avatar')
  end
end
