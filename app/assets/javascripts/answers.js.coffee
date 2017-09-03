@ready = ->
  $('.answers').on 'click', '.edit-answer-link', (e) ->
    e.preventDefault()
    $(this).hide()
    answer_id = $(this).data('answerId')
    $('form#edit-answer-' + answer_id).show()
    return        
  return     

$(document).on 'turbolinks:load', ready
$(document).on 'page:load', ready
$(document).on 'page:update', ready
