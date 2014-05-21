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
$('.expand-textarea').on('click', ->
  $(@).next().show().end().hide()
  event.preventDefault()
)

$('body').on 'ajax:success', '.line-comments form', (e, data) ->
  $li = $(e.target).parent()
  $li.before(data)

  $(e.target).find('textarea').val('')

$('.make-comment').on 'ajax:success', (e, data) ->
  $(e.target).parents('.line').after(data)
