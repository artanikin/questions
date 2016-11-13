$ ->
  questions_list = $('.questions-list tbody')

  questions_list.prepend(JST['templates/question_list']({title: 'Skim questions'}))

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
      questions_list.append('<tr><td>' + data + '</td><td></td></tr>')
  })
