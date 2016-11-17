$ ->
  commentForm = $(".new_comment")

  $("body").on "click", ".add_comment_link", (e) ->
    e.preventDefault()
    $(this).closest(".comments").find("form").show()
    $(this).hide()


  commentForm.on "ajax:success", (e, data, status, xhr) ->
    responseData = $.parseJSON(xhr.responseText)
    commentsBlock = $(this).closest(".comments")

    commentsList = commentsBlock.find(".comments-list").append(JST["templates/comment"](comment: responseData.comment))
    $(this).find("textarea").val('')
    $(this).hide()
    $("#flash").html(JST["templates/shared/message"](
      message_type: "success",
      message: responseData.message
    ))
    commentsBlock.find(".errors_block").remove()
    commentsBlock.find(".add_comment_link").show()

  .on "ajax:error", (e, xhr, status, error) ->
    responseData = $.parseJSON(xhr.responseText)

    $(this).before(JST["templates/shared/errors_block"](errors: responseData.errors.body))

    $('#flash').html(JST["templates/shared/message"](
      message_type: "danger",
      message: responseData.message
    ))
