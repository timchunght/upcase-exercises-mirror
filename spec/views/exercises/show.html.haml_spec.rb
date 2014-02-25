require 'spec_helper'

describe 'exercises/show.html' do
  it 'renders the body as markdown' do
    markdown = '*hello*'
    @exercise = build_stubbed(:exercise, body: markdown)

    render template: 'exercises/show'

    expect(rendered).to have_selector('em', text: 'hello')
  end
end
