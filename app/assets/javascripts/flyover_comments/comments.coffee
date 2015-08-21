$ ->
  $("[data-flyover-comments-reply-link='true']").click (e)->
    e.preventDefault()
    parentId = $(@).data("parent-id")
    appendToId = $(@).data("append-to")
    container = $(@).attr("href")

    if $(container).children(".flyover-comment-reply-form").length
      $(container).children(".flyover-comment-reply-form").remove()
    else
      $f = $("#flyover-comment-form").clone()
      $f.attr("id", "#flyover-comment-reply-to-#{parentId}")
      $f.data("flyover-comment-append-to", appendToId)
      $f.addClass("flyover-comment-reply-form")
      $f.find("[name='comment[parent_id]']").val(parentId)

      $(container).append($f)

  $(document).on "ajax:success", ".flyover-comment-reply-form", (e, response, status, err)->
    $form = $(@)
    appendToId = $form.data("flyover-comment-append-to")
    $(appendToId).append(response.comment_html)
    $form.remove()
