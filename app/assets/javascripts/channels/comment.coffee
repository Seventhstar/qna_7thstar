comments_channel = ->
  if gon.question_id
    App.comment = App.cable.subscriptions.create "CommentChannel",
      connected: ->
        # alert "e"
        @perform 'follow', question_id: gon.question_id

      disconnected: ->
        # Called when the subscription has been terminated by the server

      received: (data) ->
        comment = $.parseJSON(data)
        commentable_id = comment.commentable_type + '_' + comment.commentable_id
        if !gon.current_user || (gon.current_user.id != comment.user_id)
          $('ul.'+commentable_id).append  JST["templates/comment"](comment)

$(document).on 'turbolinks:load', comments_channel