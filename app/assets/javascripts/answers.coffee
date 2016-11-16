$ ->
  answers_list = $("#answers")

  answers_list.on 'click', '.edit_answer_link', (e) ->
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
      answers_list.append(JST["templates/answer"](data))
  })
