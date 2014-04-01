require 'spec_helper'

describe 'users/_user.html.haml' do
  it 'shows the users avatar' do
    user = build_stubbed(:user, avatar_url: 'http://foo.com')

    render user

    expect(rendered).to have_css("img[src='#{user.avatar_url}?s=24']")
  end
end
