App.question = App.cable.subscriptions.create "QuestionChannel",
  connected: ->
    # Called when the subscription is ready for use on the server
    #alert "connected"

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    # Called when there's incoming data on the websocket for this channel
    new_question = $.parseJSON(data)
    if !gon.current_user || (gon.current_user.id != new_question.user.id)
      $('table.table-questions').append Mustache.to_html($('#question_template').html(), new_question)



  add: ->
    @perform 'add'
