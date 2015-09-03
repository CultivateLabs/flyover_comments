$ ->
  $("[data-flyover-comments-reply-link='true']").click (e)->
    e.preventDefault()
    parentId = $(@).data("parent-id")
    container = $(@).attr("href")

    if $(container).children(".flyover-comment-reply-form").length
      $(container).children(".flyover-comment-reply-form").remove()
    else
      $f = $("#flyover-comment-form").clone()
      $f.attr("id", "#flyover-comment-reply-to-#{parentId}")
      $f.data("flyover-comment-append-to", "#flyover-comment-#{parentId}-replies")
      $f.addClass("flyover-comment-reply-form")
      $f.find("[name='comment[parent_id]']").val(parentId)

      $(container).append($f)

  $(document).on "ajax:success", ".flyover-comment-reply-form", (e, response, status, err)->
    $form = $(@)
    appendToId = $form.data("flyover-comment-append-to")
    $(appendToId).append(response.comment_html)
    $form.remove()

  $(".edit-flyover-comment-link").click (e)->
    e.preventDefault()
    commentId = $(@).data("flyover-comment-id")
    url = $(@).data("url")
    container = $(@).closest('.flyover-comment')
    content = container.find(".flyover-comment-content:first")
    if !container.children(".flyover-comment-edit-form").length
      $f = $("#flyover-comment-form").clone()
      $f.attr("id", "#flyover-comment-edit-#{commentId}")
      $f.attr("action", url)
      $f.find("input[id=comment_parent_id]").remove()
      $f.find("input[id=comment_commentable_id]").remove()
      $f.find("input[id=comment_commentable_type]").remove()
      $('<input />').attr('type', 'hidden')
          .attr('name', "_method")
          .attr('value', "put")
          .appendTo($f)
      $f.data("remote", "true")
      $f.addClass("flyover-comment-edit-form")
      $f.find("textarea").text(content.text().trim())
      content.hide()
      container.prepend($f)

  $(document).on "ajax:success", ".flyover-comment-edit-form", (e, response, status, err)->
    container = $(@).closest('.flyover-comment')
    content = container.find(".flyover-comment-content:first")
    content.html(response.content_html)
    content.show()
    $(@).remove()

  $(".edit-flyover-comment-cancel").click (e)->
    e.preventDefault()
