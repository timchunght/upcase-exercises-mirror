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

  it 'highlights changed lines' do
    render_lines([
     unchanged( 'class Example' ),
     changed(   '  def one'     ),
     changed(   '  end'         ),
     unchanged( ''              ),
     unchanged( '  def two'     ),
     unchanged( '  end'         ),
     unchanged( 'end'           )
    ])

    expect(added_text.strip_heredoc).to eq(<<-TEXT.strip_heredoc)
      def one
      end
    TEXT
  end

  it 'marks blank lines' do
    input = <<-EOS.strip_heredoc
      one

      two

      three
    EOS

    render_file input

    expect(blank_lines.length).to eq(2)
  end

  it 'escapes markup 'do
    input = '<p>Hello</p>'

    render_file input

    expect(rendered_text.strip).to eq(input)
  end

  def render_file(contents)
    lines = contents.each_line.map { |text| unchanged(text.rstrip) }
    render_lines lines
  end

  def render_lines(lines)
    solution = double('solution')
    file = double('file', name: 'example.txt')
    comment_locator = double('comment_locator', inline_comments_for: [])
    yield_each(file.stub(:each_line), lines)

    render(
      'solutions/file',
      file: file,
      solution: solution,
      comment_locator: comment_locator
    )
  end

  def yield_each(starting_stub, enumerable)
    enumerable.inject(starting_stub) { |stub, item| stub.and_yield(item) }
  end

  def changed(text)
    line(text, true)
  end

  def unchanged(text)
    line(text, false)
  end

  def line(text, changed)
    double(
      "line: #{text}",
      text: text,
      changed?: changed,
      blank?: text.blank?,
      number: 1,
      new_comment_path: '',
      comments: [],
    )
  end

  def rendered_text
    lines('code')
  end

  def added_text
    lines('.comments code')
  end

  def blank_lines
    lines('.blank code')
  end

  def lines(selector)
    Capybara.string(rendered).all(selector).map { |node| "#{node.text}\n" }.join
  end
end
