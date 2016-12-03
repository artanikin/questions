$(document).on 'turbolinks:load', ->
  questions_list = $('.questions-list tbody')

  $('.edit-question-link').click (e) ->
    $(this).hide()
    question_id = $(this).data('questionId')
    $('form#edit_question_' + question_id).show()
    e.preventDefault()

  App.cable.subscriptions.create('QuestionsChannel', {
    connected: ->
      if questions_list.length
        @perform 'follow'
      else
        @perform 'unfollow'
    ,
    received: (data) ->
      questions_list.append(JST['templates/question_list']($.parseJSON(data)))
  })
