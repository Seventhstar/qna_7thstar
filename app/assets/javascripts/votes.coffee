# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

votes = (el, show_cls, hide_cls, rating) ->
  votable_id = el.data('votableId')
  votable_type = el.data('votableType')
  vol_type = '#' + votable_type.toLowerCase() + '_' + votable_id
  $(vol_type + show_cls).show()
  $(vol_type + hide_cls).hide()
  $(vol_type + ' .rate').html(rating)
  $('div.errors').html()
  return

vote_error = (el, data) ->
  result = $.parseJSON(data.responseText)
  votable_type = el.data('votableType').toLowerCase()
  $('.' + votable_type + 's .errors').append('<p>' + result.error + '</p>')
  return
  

ready_votes = ->
  $(document).off 'ajax:success', '.vote-link'
  .off 'ajax:error', '.vote-link'
  $(document).on 'ajax:success', '.vote-link', (e, data, status, xhr) ->
    votes $(this), ' .reset-vote-link', ' .vote-link', data.rating
    return
  .on 'ajax:error', '.vote-link', (e, data, status, xhr) ->
    vote_error $(this),data
    return

  $(document).off 'ajax:success', '.reset-vote-link'
  .off 'ajax:error', '.reset-vote-link'
  $(document).on 'ajax:success', '.reset-vote-link', (e, data, status, xhr) ->
    votes $(this), ' .vote-link',' .reset-vote-link', data.rating
    return
  .on 'ajax:error', '.reset-vote-link', (e, data, status, xhr) ->
    vote_error $(this),data
    return
  return

$(document).on 'turbolinks:load', ready_votes