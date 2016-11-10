vote = ->
  $('.vote_up, .vote_down').on 'ajax:success', (e, data, status, xhr) ->
    response_data = $.parseJSON(xhr.responseText)
    rating_block = $(this).closest('.rating_block')
    rating_block.find('.rating').html(response_data.rating)

    $('#flash').html('<div class="alert alert-success">' + response_data.message + '</div>')

  .on 'ajax:error', (e, xhr, status, error) ->
    errors = $.parseJSON(xhr.responseText)
    message = ''
    $.each errors, (index, value) ->
      message += '<p>' + value + '</p>'

    $('#flash').html('<div class="alert alert-danger">' + message + '</div>')

$(document).ready(vote)
$(document).on('page:load', vote)
$(document).on('page:update', vote)
$(document).on('turbolinks:load', vote)
