ready_answer = ->
  $('.answers').on 'click', '.delete-answer', (e) ->
    e.preventDefault()
    if confirm "Are you sure?"
      answer_id = $(this).data('answerId')
      $.ajax
        url: '/answers/'+answer_id
        dataType: 'json'
        type: 'DELETE'
        success: (data) ->
          $('.answers li#answer_'+answer_id).remove();
          $('.answers p.notice').html(data.message)
          return
    return

  $('.answers').on 'click', '.edit-answer-link', (e) ->
    e.preventDefault()
    $(this).hide()
    answer_id = $(this).data('answerId')
    $('form#edit-answer-' + answer_id).show()
    return    
   
  $('.answers').on 'click', '.set-best-answer', (e) ->
    e.preventDefault()
    answer_id = $(this).data('answerId')
    question_id = $('.question').data('questionId')
    $.ajax
      type: "PATCH"
      url: "/answers/" + answer_id + "/set_best"
      dataType: "json"
      data:
        id: answer_id
        question_id: question_id
      success: (data) ->
        message = data.message
        li_answer_id = 'li#answer_' + answer_id
        $('.answers p.notice').html(message);
        $('.answers p.glyphicon').removeClass('glyphicon-ok');
        $(li_answer_id + ' p.glyphicon').addClass('glyphicon-ok');
        $('.set-best-answer').show();
        $(li_answer_id + ' a').last().hide();
        $(li_answer_id).parent().prepend($(li_answer_id))
        return
      error: ->
        $('.answers p.notice').html('Something is wrong.')
        return
    return
  return


$(document).on 'turbolinks:load', ready_answer


