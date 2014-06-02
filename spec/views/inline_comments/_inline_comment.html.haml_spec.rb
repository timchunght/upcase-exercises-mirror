require 'spec_helper'

describe 'inline_comments/_inline_comment.html' do
  it_behaves_like :markdown_enabled_view do
    def render_markdown(markdown)
      comment = build_stubbed(:inline_comment, text: markdown)

      render comment
    end
  end
end
