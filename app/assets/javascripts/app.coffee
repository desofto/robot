$ ->
  $('.city').autocomplete({
    source: '/api/v1/airports'
    minLength: 2
    select: (event, ui) ->
      $(this).val(ui.item.label)
      $(this).next().val(ui.item.value)
      false
    focus: (event, ui) ->
      $(this).val(ui.item.label)
      return false
  })

  $('.date').datepicker({ dateFormat: 'yy-mm-dd' })

  $('.search').click ->
    $.get('/api/v1/airlines', (airlines) =>
      form = $(this).closest('.form')
      results = form.find('.results')
      results.empty()
      for airline in airlines
        process = (airline) ->
          results.append('<div class="results-' + airline.code + '">Loading from ' + airline.name + '...</div>')
          from = form.find('.city.from').next().val()
          to = form.find('.city.to').next().val()
          date = form.find('.date').val()
          $.get('/api/v1/search?airline=' + airline.code + '&from=' + from + '&to=' + to + '&date=' + date, (flights) ->
            result = results.find('.results-' + airline.code)
            result.empty()
            for flight in flights
              result.append('<div class="result">' +
                '<div class="airline">' + flight.airline.name + '</div>' +
                '<div class="from">' + flight.start.airportName + ' in ' + flight.start.cityName + ' at ' + flight.start.dateTime + '</div>' +
                '<div class="divider">=&gt;</div>' +
                '<div class="to">' + flight.finish.airportName + ' in ' + flight.finish.cityName + ' at ' + flight.finish.dateTime + '</div>' +
                '<div class="plane">Plane: ' + flight.plane.fullName  + '</div>' +
                '<div class="clearfix"></div>' +
              '</div>')
          )
        process(airline)
    )
