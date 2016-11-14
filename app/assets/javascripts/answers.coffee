$ ->
  $('.edit_answer_link').click (e) ->
    e.preventDefault()
    $(this).hide()
    answer_id = $(this).data('answerId')
    $('#edit_answer_' + answer_id).show()
