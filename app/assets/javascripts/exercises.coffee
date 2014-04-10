$('.exercise-demo').on 'click', 'li', (event) ->
  $(@).parent().find('.active').addClass('completed')
  $(@).addClass('active').siblings().removeClass('active')
  if $(@).is(':last-child')
    $(@).addClass('completed')
  false
