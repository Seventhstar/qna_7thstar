@ready = ->
  $('.answers').on 'click', '.edit-answer-link', (e) ->
    e.preventDefault();
    $(this).hide();
    answer_id = $(this).data('answerId')
    $('form#edit-answer-' + answer_id).show()
    return        

  $('.answers').on 'click', '.set-best-answer', (e) ->
    answer_id = $(this).data('answerId')
    question_id = $(this).data('questionId')
    $.ajax
      type: "PATCH"
      url: "/answers/" + answer_id + "/set_best"
      dataType: "json"
      data:
        id: answer_id
        question_id: question_id
      success: (data) ->  
        $('.answers p.notice').html(data.message)
        li_answer_id = 'li#answer_' + answer_id
        $('.answers p').removeClass('glyphicon glyphicon-ok')
        $(li_answer_id + ' p').addClass('glyphicon glyphicon-ok')
        $('.set-best-answer').show()
        $(li_answer_id + ' a').last().hide()
        $('.answers p.notice').html(data.message)
        $(li_answer_id).parent().prepend($(li_answer_id))

        return
      error: (evt, xhr, status, error) ->      
        $('.answers p.notice').html('Error: '+ evt.responseText)
        return
    return 
  return     

$(document).on 'turbolinks:load', ready
$(document).on 'page:load', ready
$(document).on 'page:update', ready
