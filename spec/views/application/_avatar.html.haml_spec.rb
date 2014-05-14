require 'spec_helper'

describe 'application/_avatar.html.haml' do
  it "renders the user's avatar" do
    user = build_stubbed(:user, avatar_url: 'http://foo.com')

    render 'avatar', user: user

    expect(rendered).to have_css("img[src='#{user.avatar_url}?s=24']")
  end
end
