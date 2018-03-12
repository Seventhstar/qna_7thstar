answers_channel = ->
  if gon.question_id
    App.answer = App.cable.subscriptions.create channel:"AnswerChannel", question_id: gon.question_id,
      connected: ->
        # Called when the subscription is ready for use on the server
        @perform 'follow', question_id: gon.question_id

      disconnected: ->
        # Called when the subscription has been terminated by the server

      received: (data) ->
        # Called when there's incoming data on the websocket for this channel
        # alert "received"
        new_answer = $.parseJSON(data)
        new_answer.current_user = gon.current_user
        if !gon.current_user || (gon.current_user.id != new_answer.user.id)
          $('.answers>ul').append JST['templates/answer'](new_answer)
          # ready_comment()
          return

$(document).on 'turbolinks:load', answers_channel