$ ->
  questions_list = $('.questions-list tbody')

  $('.edit-question-link').click (e) ->
    $(this).hide()
    question_id = $(this).data('questionId')
    $('form#edit_question_' + question_id).show()
    e.preventDefault()

  App.cable.subscriptions.create('QuestionsChannel', {
    connected: ->
      @perform 'follow'
    ,
    received: (data) ->
      console.log data
      question = $.parseJSON(data)
      console.log '-----------------'
      console.log question
      # questions_list.append('<tr><td>' + data + '</td><td></td></tr>')
      questions_list.prepend(JST['templates/question_list']({question: question}))
  })
