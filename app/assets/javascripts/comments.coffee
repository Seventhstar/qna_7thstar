# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
ready_comment = ->
  $('._comments').on 'click', '.edit-comment-link', (e) ->
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

$(document).on('turbolinks:load', ready_comment)
$(document).on('page:load', ready_comment)
$(document).on('page:update', ready_comment)
