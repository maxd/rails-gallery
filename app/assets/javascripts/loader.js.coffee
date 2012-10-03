$ ->
  $(document).on 'click', "[data-toggle='load']", (event) ->
    currentElement = $(event.currentTarget)

    href = $(@).data('href')
    target = $(@).data('target')
    success = $(@).data('success')

    $(target).load href, ->
      $(target).trigger('content-loaded')
      window[success](currentElement) if success
