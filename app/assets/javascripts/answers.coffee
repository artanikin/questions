$(document).on 'turbolinks:load', ->
  answers_list = $("#answers")

  answers_list.on 'click', '.edit_answer_link', (e) ->
    e.preventDefault()
    $(this).hide()
    answer_id = $(this).data('answerId')
    $('#edit_answer_' + answer_id).show()

  $('#new_answer').on 'ajax:error', (e, xhr, status, error) ->
    if xhr.status == 401
      $('#flash').html(JST["templates/shared/message"](
        message_type: "danger",
        message: xhr.responseText
      ))

  App.cable.subscriptions.create("AnswersChannel", {
    connected: ->
      question_id = $('.question').data('questionId')
      if question_id
        @perform 'follow', question_id: question_id
      else
        @perform 'unfollow'
    ,
    received: (data) ->
      data = $.parseJSON(data)
      answers_list.append(JST["templates/answer"](data))
  })
