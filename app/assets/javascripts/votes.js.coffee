$('.vote_up').on 'ajax:success', (e, data, status, xhr) ->
  console.log('success')
    # answer = $.parseJSON(xhr.responseText)
    # $('.answers').append('<p>' + answer.body + '</p>')
  .on 'ajax:error', (e, xhr, status, error) ->
    console.log('error')
    # errors = $.parseJSON(xhr.responseText)
    # $.each errors, (index, value) ->
    #   $('.answer-errors').append(value)
