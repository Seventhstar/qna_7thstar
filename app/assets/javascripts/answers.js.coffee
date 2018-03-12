ready_answer = ->
  $('form.new_answer').on 'ajax:success',(e, data, status, xhr) ->
    answer = $.parseJSON(xhr.responseText)
    $('.answers>ul').append JST['templates/answer'](answer)
    $('input#answer_body').val('')
    $('.remove_fields').click()
    return
  .on 'ajax:error', (e, xhr, status, error) ->
    errors = $.parseJSON(xhr.responseText)
    $.each errors, (index, value) ->
      $('.answers .errors').append('<p>'+value+'</p>')
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
        $(li_answer_id + ' a.set-best-answer').hide();
        $(li_answer_id).parent().prepend($(li_answer_id))
        return
      error: ->
        $('.answers p.notice').html('Something is wrong.')
        return
    return
  return

$(document).on 'turbolinks:load', ready_answer


