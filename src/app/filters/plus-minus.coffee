app.filter 'plusMinus', ->
  (value) ->
    if value > 0
      '+' + value
    else if value < 0
      '−' + Math.abs value
    else
      value
