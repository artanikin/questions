$ ->
  answers_list = $("#answers")

  answers_list.on 'click', '.edit_answer_link', (e) ->
    e.preventDefault()
    $(this).hide()
    answer_id = $(this).data('answerId')
    $('#edit_answer_' + answer_id).show()

  App.cable.subscriptions.create("AnswersChannel", {
    connected: ->
      question_id = $('.question').data('questionId')
      if question_id
        @perform 'follow', question_id: gon.question_id
      else
        @perform 'unfollow'
    ,
    received: (data) ->
      data = $.parseJSON(data)
      answers_list.append(JST["templates/answer"](data))
  })
