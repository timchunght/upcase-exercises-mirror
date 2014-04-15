require 'spec_helper'

describe 'solutions/_file.html.haml' do
  it 'preserves whitespace' do
    input = <<-EOS.strip_heredoc
      class Example
        def one
        end

        def two
        end
      end
    EOS

    render_file input

    expect(rendered_text).to eq(input)
  end

  def render_file(contents)
    file = StringIO.new(contents)
    file.stub(:name).and_return('example.txt')

    render 'solutions/file', file: file
  end

  def rendered_text
    lines.map(&:text).join
  end

  def lines
    Capybara.string(rendered).all('code')
  end
end
