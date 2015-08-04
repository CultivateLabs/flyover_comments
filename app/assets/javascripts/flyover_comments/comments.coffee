$ ->
  $("[data-flyover-comment-reply-to]").click (e)->
    e.preventDefault()
    replyToId = $(@).data("flyover-comment-reply-to")
    appendToId = $(@).data("flyover-comment-append-to")
    container = $(@).attr("href")
    $replyForm = $("#flyover-comment-form").clone()
    $replyForm.attr("id", "#flyover-comment-reply-to-#{replyToId}")
    $replyForm.data("flyover-comment-append-to", appendToId)
    $replyForm.addClass("flyover-comment-reply-form")
    $replyForm.find("[name='comment[parent_id]']").val(replyToId)
    $(container).append($replyForm)
  
  $(document).on "ajax:success", ".flyover-comment-reply-form", (e, response, status, err)->
    $form = $(@)
    appendToId = $form.data("flyover-comment-append-to")
    $(appendToId).append(response.comment_html)
    $form.remove()