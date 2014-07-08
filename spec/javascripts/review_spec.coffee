#= require application
#= require sinon
#= require sinon-chai
#= require chai-jquery

describe "Review", ->
  beforeEach ->
    sinon.spy(window, "prettyPrint")

  afterEach ->
    prettyPrint.restore()

  body = (html) ->
    $("body").html(html).find("[data-role=review]")

  commentsTemplate = """
    <div>
      <ol data-role="inline-comments">
        <li data-role="comment-form" style="display: none">
          <form>
            <input type="hidden" name="comment[location]" />
            <textarea name="comment[body]"></textarea>
          </form>
        </li>
        <li data-role="form-toggle">
          <button>Add Comment</button>
        </li>
      </ol>
    </div>
  """

  templates = """
    <script type="text/html" data-template="inline-comments">
      #{commentsTemplate}
    </script>
    <div data-role="make-comment">
      <a href="#"></a>
    </div>
    <div data-role="top-level-comments">
      <ol>
        <li data-role="comment-form">
          <form>
            <textarea name="comment[body]"></textarea>
          </form>
        </li>
      </ol>
    </div>
  """

  makeTemplate = (file) ->
    reviewElement = $("<div/>").attr("data-role": "review")
    reviewElement.append buildFileMarkup(file)
    reviewElement.append(templates)
    body reviewElement[0].outerHTML

  buildFileMarkup = (file) ->
    locationTemplate = "#{file.location || '?'}"
    fileElement = $("<div/>").attr
      "data-role": "file"
      "data-location": locationTemplate

    $.each file.lines, (index, line) ->
      lineNumber = index + 1
      location = locationTemplate.replace("?", lineNumber)
      fileElement.append buildLineMarkup(line)
      if line.comments?
        fileElement.append buildCommentsMarkup(location, line.comments)

    fileElement

  buildLineMarkup = (line) ->
    pre = $("<pre/>").text(line.text)
    $("<div/>").attr("data-role": "line").append(pre)

  buildCommentsMarkup = (location, comments) ->
    commentsElement = $(commentsTemplate)
    commentsElement.attr("data-comments-for": location)
    for comment in comments
      commentElement =
        $('<li/>').attr("data-role": "comment").text(comment)
      commentsElement.
        find("[data-role=comment-form]").
        before(commentElement)
    commentsElement

  inlineCommentForm = ->
    $("[data-role=inline-comments] form")

  commentsForLocation = (location) ->
    $("[data-role=line] + [data-comments-for='#{location}']")

  mouseOverLine = (text) ->
    line =
      if text?
        $("pre:contains('#{text}')")
      else
        $("pre").eq(0)
    expect(line.length).to.eq(1)
    line.mouseover()

  mouseOutLine = ->
    $("pre").mouseout()

  clickInlineCommentIcon = ->
    $("[data-role=make-comment] a").click()

  openCommentForm = ->
    $("[data-role=form-toggle] button").click()

  expectToAddInlineCommentTo = (data) ->
    template = makeTemplate
      location: "123:file:?"
      lines: [
        $.extend { text: "Line" }, data
      ]

    new Review(template)
    mouseOverLine()
    clickInlineCommentIcon()
    template.find("textarea").val("New comment")

    inlineCommentForm().trigger("ajax:success", "<li>New comment</li>")

    expect(template.find("textarea")).to.have.value("")
    expect(inlineCommentForm()).to.be.hidden
    expect(commentsForLocation("123:file:1").text()).
      to.include("New comment")

  it "highlights code blocks", ->
    template = makeTemplate lines: [{ text: "one" }, { text: "two" }]

    new Review(template)

    expect(template.find("pre")).to.have.class("prettyprint")
    expect(prettyPrint).to.have.been.called

  it "displays an inline comment form for the first comment", ->
    template = makeTemplate
      location: "123:file:?"
      lines: [
        { text: "one" }
        { text: "two" }
        { text: "three" }
      ]

    new Review(template)
    focused = null
    $("body").on "focus", "*", (event) ->
      focused = event.target

    mouseOverLine("two")
    clickInlineCommentIcon()

    expect(template.find("input[name='comment[location]']")).
      to.have.value("123:file:2")
    expect(inlineCommentForm()).to.be.visible
    expect(focused).to.eq(template.find("textarea")[0])

  it "displays an inline comment form for the second comment", ->
    template = makeTemplate
      location: "123:file:?"
      lines: [
        { text: "one", comments: ["first"] }
      ]

    new Review(template)

    openCommentForm()

    expect(template.find("input[name='comment[location]']")).
      to.have.value("123:file:1")
    expect(inlineCommentForm()).to.be.visible
    expect(template.find("button")).to.be.hidden
    expect(inlineCommentForm().length).to.equal(1)

  it "toggles the inline comment form", ->
    template = makeTemplate lines: [{ text: "Line" }]

    new Review(template)
    mouseOverLine()
    clickInlineCommentIcon()

    clickInlineCommentIcon()
    expect(inlineCommentForm().length).to.equal(1)
    expect(inlineCommentForm()).to.be.hidden
    expect(template.find("button")).to.be.hidden

    clickInlineCommentIcon()
    expect(inlineCommentForm().length).to.equal(1)
    expect(inlineCommentForm()).to.be.visible
    expect(template.find("button")).to.be.hidden

  it "only adds one hover target", ->
    template = makeTemplate lines: [{ text: "Line" }]

    new Review(template)

    mouseOverLine()
    mouseOutLine()
    mouseOverLine()

    expect(template.find('a').length).to.equal(1)

  it "adds the first inline comment", ->
    expectToAddInlineCommentTo comments: []

  it "adds the second inline comment", ->
    expectToAddInlineCommentTo comments: ["first"]

  it "adds a top-level comment", ->
    template = makeTemplate lines: []

    new Review(template)
    template.find("textarea").val("text")

    template.
      find("[data-role=top-level-comments] form").
      trigger("ajax:success", "<li>New comment</li>")

    topLevelComments = template.find("[data-role=top-level-comments]")
    commentText = topLevelComments.find("li").text()
    expect(commentText).to.include("New comment")
    commentBeforeForm =
      topLevelComments.
        find("li:contains('New comment') + [data-role=comment-form]").
        length
    expect(commentBeforeForm).to.eq(1)
    expect(topLevelComments.find("textarea")).to.have.value("")
