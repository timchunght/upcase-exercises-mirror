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
)
$('.expand-textarea').on('click', ->
  $(@).next().show().end().hide()
)
$('.make-comment').on('click', ->
  $comment = $(@).parent().next('.line-comments')
  if $comment.is(':visible')
    $comment.hide()
  else
    $comment.show()
    $comment.find('.expand-textarea').hide().next().show()
)
