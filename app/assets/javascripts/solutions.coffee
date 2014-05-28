$ ->
  prettyPrint()

$container = $('section.code')
$container.masonry {
  itemSelector: '.file',
  containerStyle: null,
  transitionDuration: '.3s'
}

$('.show-comments').on('click', ->
  $comments = $(@).parent().next()
  if $comments.is(':visible')
    $comments.hide()
  else
    $comments.show()
  event.preventDefault()
)

$('body').on 'ajax:success', '.line-comments .new_inline_comment', (e, data) ->
  $li = $(e.target).parent()
  $li.before(data)

  $(e.target).find('textarea').val('')

$('.make-comment').on 'ajax:success', (e, data) ->
  $commentThread = $(e.target).parents('.line').next()

  if $commentThread.hasClass('line-comments')
    unless $commentThread.find('form').hasClass('new_inline_comment')
      $form = $(data).find('li')
      $commentThread.find('ol').append($form)
  else
    $(e.target).parents('.line').after(data)

$('.show-form form').on 'ajax:success', (e, data) ->
  $form = $(data).find('li')
  $container = $(e.target).parents('li')

  $container.before($form)
  $container.hide()
