# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

votes = (e, el,type,url, show_cls, hide_cls)->
  e.preventDefault()
  value = el.data('value')
  votable_id = el.data('votableId')
  votable_type = el.data('votableType')

  $.ajax
    type: type
    url: url
    data:
      value: value
      votable_id: votable_id
      votable_type: votable_type

    success: (rating) ->
      vol_type = '#' + votable_type.toLowerCase() + '_' + votable_id
      
      $(vol_type + show_cls).show()
      $(vol_type + hide_cls).hide()

      $(vol_type + ' .rate').html(rating)

      $('div.errors').html()
      return
    error: (xhr) ->
      $('div.errors').html('Error: ' + xhr.status + ' ' + xhr.statusText)
  return
  

ready_votes = ->
  $(document).on 'click', '.vote-link', (e) ->
    votes e, $(this), "POST","/votes", ' .reset-vote-link', ' .vote-link'
    return

  $(document).on 'click', '.reset-vote-link', (e) ->
    votes e, $(this), "DELETE", "/votes/reset", ' .vote-link',' .reset-vote-link'
    return

$(document).on 'turbolinks:load', ready_votes