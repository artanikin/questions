$(document).on 'turbolinks:load', ->
  $('.vote_up, .vote_down').on 'ajax:success', (e, data, status, xhr) ->
    response_data = $.parseJSON(xhr.responseText)
    rating_block = $(this).closest('.rating_block')
    rating_block.find('.rating').html(response_data.rating)

    $('#flash').html(JST["templates/shared/message"](
      message_type: "success",
      message: response_data.message
    ))

  .on 'ajax:error', (e, xhr, status, error) ->
    errors = $.parseJSON(xhr.responseText)
    message = ''
    $.each errors, (index, value) ->
      message += value

    $('#flash').html(JST["templates/shared/message"](
      message_type: "danger",
      message: message
    ))
