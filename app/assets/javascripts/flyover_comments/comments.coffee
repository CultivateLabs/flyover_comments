$ ->
  $(document).on "click", "[data-flyover-comments-reply-link='true']", (e)->
    e.preventDefault()
    parentId = $(@).data("parent-id")
    container = $(@).data("flyover-comments-form-container") || $(@).attr("href")

    $(container).each ->
      if $(@).children(".flyover-comment-reply-form").length
        $(@).children(".flyover-comment-reply-form").remove()
      else
        $f = $("#flyover-comment-form").clone()
        $f.attr("id", "#flyover-comment-reply-to-#{parentId}")
        $f.data("flyover-comment-append-to", "#flyover-comment-#{parentId}-replies")
        $f.addClass("flyover-comment-reply-form")
        $f.find("[name='comment[parent_id]']").val(parentId)

        $(@).append($f)

  $(document).on "ajax:success", ".flyover-comment-reply-form", (e, response, status, err)->
    $form = $(@)
    appendToId = $form.data("flyover-comment-append-to").replace(/^#/, "")
    $("[id=#{appendToId}]").each ->
      $(@).append(response.comment_html)
    $form.remove()

  $(document).on "ajax:success", ".flyover-comment-flag-form", (e, response, status, err)->
    $f = $(@)
    $f.find("textarea[id=flag_reason]").val("")
    $modal = $f.closest(".modal")
    $modal.modal("hide")

  $(document).on "click", ".flag-flyover-comment-modal-link", (e)->
    e.preventDefault()
    url = $(@).data("url")
    $modal = $("#flyover-comment-flag-modal")
    $f = $modal.find("form")
    $f.attr("action", url)

  $(document).on "click", ".edit-flyover-comment-link", (e)->
    e.preventDefault()
    commentId = $(@).data("flyover-comment-id")
    url = $(@).data("url")
    container = $("[id=flyover_comment_#{commentId}]")
    $(container).each ->
      content = $(@).find(".flyover-comment-content:first")
      if !$(@).children(".flyover-comment-edit-form").length
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
        $f.data("type", "json")
        $f.addClass("flyover-comment-edit-form")
        $f.find("input[class=comment_cancel]").show()
        textarea = $f.find("textarea")
        textarea.attr("id", "comment_content_"+commentId)
        textarea.text(content.text().trim())
        content.hide()
        $(@).prepend($f)

  $(document).on "ajax:success", ".flyover-comment-edit-form", (e, response, status, err)->
    $(@).remove()
    $("[id=flyover_comment_#{response.id}]").each ->
      content = $(@).find(".flyover-comment-content:first")
      content.html(response.content_html)
      content.show()
      $(@).find(".flyover-comment-edit-form").remove()

  $(document).on "click", ".flyover-comment-cancel", (e)->
    e.preventDefault()
    $(this).closest(".flyover-comment").find(".flyover-comment-content").show()
    $(this).closest(".flyover-comment-form").remove()
