ready = ->
  $('.edit-question-link').click (e) ->
    $(this).hide()
    question_id = $(this).data('questionId')
    $('form#edit_question_' + question_id).show()
    e.preventDefault()

$(document).ready(ready)
$(document).on('page:load', ready)
$(document).on('page:update', ready)
