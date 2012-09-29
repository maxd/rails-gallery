$ ->
  $(document).on 'click', '.select-items-scope', (event) ->
    currentElement = $(event.currentTarget);

    $('.select-items-scope').removeClass('active')
    currentElement.addClass('active')

    href = currentElement.data('href')
    $('.items').load(href)