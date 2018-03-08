# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

  ready_comment = ->
    $('form.new_comment').on('ajax:success', (e, data, status, xhr) ->
      comment = undefined
      id = $(this).closest('form').attr('id')
      type = $('#'+id+' #comment_type').val().toLowerCase()
      $('#'+id+' #comment_body').val ''
      comment = $.parseJSON(xhr.responseText)
      $('ul.'+id).append Mustache.to_html($('#comment_template').html(), comment)
      return
    ).on 'ajax:error', (e, xhr, status, error) ->
      errors = undefined
      errors = $.parseJSON(xhr.responseText)
      $.each errors, (index, value) ->
        $('.question_comments .errors').append '<p>' + value + '</p>'
        return
      return
    $('.question_comments').on 'click', '.edit-comment-link', (e) ->
      comment_id = undefined
      e.preventDefault()
      $(this).hide()
      comment_id = $(this).data('commentId')
      $('form#edit-comment-' + comment_id).show()
      return
    $('.container').on 'click', '.add-comment', (e) ->
      comment_id = undefined
      e.preventDefault()
      $(this).hide()
      commentable_id = $(this).data('commentable-id')
      $('form#' + commentable_id).show()
      return
    return

  $(document).on 'turbolinks:load', ready_comment
  return