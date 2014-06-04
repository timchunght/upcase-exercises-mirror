waitForClone = () ->
  $.ajax
    method: 'GET'
    url: $('#overview').data('clone-url')
    success: (html) ->
      $('#overview').html(html)
    error: ->
      setTimeout(waitForClone, 2000)

$('body').on 'ajax:success', '#overview form', (e, html) ->
  $('#overview').html(html)
  waitForClone()
