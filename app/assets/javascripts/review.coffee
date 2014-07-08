class @Review
  constructor: (@element) ->
    @element.find("[data-role=file]").each (_, element) =>
      new File(this, $(element), @template("inline-comments"))
    @hoverIcon = @element.find("[data-role=make-comment]")
    @prepareTopLevelComments()
    prettyPrint()

  prepareTopLevelComments: ->
    @topLevelComments = new TopLevelComments(
      this,
      @element.find("[data-role=top-level-comments]")
    )

  lineHovered: (line) ->
    @hoverIcon.remove()
    line.showMakeCommentIcon(@hoverIcon)

  makeCommentClicked: (line) =>
    line.toggleCommentForm()

  commentFormSubmitted: (container, result) =>
    container.addComment(result)
    container.closeCommentForm()

  template: (name) ->
    @element.find("[data-template='#{name}']").html()

class TopLevelComments
  constructor: (@review, @element) ->
    @element.
      find("form").
      on("ajax:success", @topLevelCommentSubmitted)

  topLevelCommentSubmitted: (event, result) =>
    @review.commentFormSubmitted(this, result)

  addComment: (html) ->
    @element.find("[data-role=comment-form]").before(html)

  closeCommentForm: ->
    @element.find("textarea").val("")

class File
  constructor: (@review, @element, @commentsTemplate) ->
    @element.find("[data-role=line]").each (index, element) =>
      lineNumber = index + 1
      locationTemplate = @element.data("location")
      location = locationTemplate.replace("?", lineNumber)
      new Line(@review, $(element), location, @commentsTemplate)

class Line
  constructor: (@review, @element, @location, @commentsTemplate) ->
    @element.on "mouseenter", @mouseEnter
    @element.find("pre").addClass("prettyprint")
    @findComments()

  mouseEnter: =>
    @review.lineHovered(this)

  showMakeCommentIcon: (icon) ->
    icon.prependTo(@element)
    icon.on "click", @makeCommentClicked

  makeCommentClicked: (event) =>
    event.preventDefault()
    @review.makeCommentClicked(this)

  toggleCommentForm: () ->
    unless @comments?
      @renderComments()

    if @commentForm().is(":visible")
      @closeCommentForm()
    else
      @openCommentForm()

  closeCommentForm: ->
    @commentForm().find("textarea").val("")
    @commentForm().hide()
    if @hasComments()
      @formToggle().show()

  openCommentForm: ->
    @commentForm().show()
    @formToggle().hide()
    @commentForm().find("textarea").focus()

  commentForm: () ->
    @comments.find("[data-role=comment-form]")

  formToggle: () ->
    @comments.find("[data-role=form-toggle]")

  addComment: (html) ->
    @commentForm().before(html)

  prepareComments: ->
    @comments.find("form").on("ajax:success", @commentFormSubmitted)
    @comments.find("input[name='comment[location]']").val(@location)
    @formToggle().on("click", @makeCommentClicked)

  findComments: ->
    comments = $("[data-comments-for='#{@location}']")
    if comments.length > 0
      @comments = comments
      @prepareComments()

  renderComments: ->
    @comments = $(@commentsTemplate)
    @comments.attr("data-comments-for": @location)
    @element.after(@comments)
    @prepareComments()

  hasComments: ->
    @comments.find("[data-role=comment]").length > 0

  commentFormSubmitted: (_, result) =>
    @review.commentFormSubmitted(this, result)
