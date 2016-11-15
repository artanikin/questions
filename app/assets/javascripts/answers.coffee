$ ->
  answers_list = $("#answers")

  $('.edit_answer_link').click (e) ->
    e.preventDefault()
    $(this).hide()
    answer_id = $(this).data('answerId')
    $('#edit_answer_' + answer_id).show()

  App.cable.subscriptions.create("AnswersChannel", {
    connected: ->
      @perform 'follow'
    ,
    received: (data) ->
      data = $.parseJSON(data)
      answers_list.append(JST["templates/answer"](data.answer))
  })
