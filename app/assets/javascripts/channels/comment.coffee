comments_channel = ->
  if gon.question_id
    App.comment = App.cable.subscriptions.create "CommentChannel",
      connected: ->
        @perform 'follow', question_id: gon.question_id

      received: (data) ->
        comment = $.parseJSON(data)
        commentable_id = comment.commentable_type.toLowerCase() + '_' + comment.commentable_id
        if !gon['current_user'] || (gon.current_user.id != comment.user_id)
          $('ul.'+commentable_id).append  JST["templates/comment"](comment)

$(document).on 'turbolinks:load', comments_channel