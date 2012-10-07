$ ->
  $(document).on 'click', "[data-toggle='open-modal']", ->
    url = $(@).data('href')
    window.successHandler = $(@).data('success')

    $('.modal-dialog').load url, ->
      $('.modal-dialog .modal').modal('show')

    false

  $(document).on 'click', '.modal-dialog .confirm-button', ->
    form = $('.modal-dialog form')
    $.post form.attr('action'), form.serialize(), ->
      window[window.successHandler]()
      $('.modal-dialog .modal').modal('hide')
    .error (data) ->
      $('.modal-dialog .modal-body').html(data.responseText)

    false

  $(document).on 'submit', '.modal-dialog form', ->
    $('.modal-dialog .confirm-button').click()
    false