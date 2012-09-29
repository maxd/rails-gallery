$ ->
  $(document).on 'click', '.select-items-scope', (event) ->
    currentElement = $(event.currentTarget)

    $('.select-items-scope').removeClass('active')
    currentElement.addClass('active')

    href = currentElement.data('href')
    $('.items').load(href)

    false


  $(document).on 'click', '.items-filter', (event) ->
    currentElement = $(event.currentTarget)

    href = currentElement.attr('href')
    $('.items').load(href)

    false
