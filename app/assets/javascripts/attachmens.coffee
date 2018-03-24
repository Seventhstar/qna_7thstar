# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

delete_attachments = ->
  $(document).on 'click', '.delete-attachment-link', (e) ->
    e.preventDefault();
    attachment_id = $(this).data('attachment-id')
    owner = $(this).data('owner')
    $.ajax
      type: "DELETE"
      url: "/attachments/" + attachment_id
      dataType: "json"
      data:
        id: attachment_id
      success: ->        
        $('.'+owner+'_attachments #attachment_'+ attachment_id).remove();
        return
      error: ->
        $('.'+owner+'_attachments div.errors').html('Error deleting attachment.')
        return
    return

$(document).on 'turbolinks:load', delete_attachments


