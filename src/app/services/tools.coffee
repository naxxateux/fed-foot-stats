app.factory 'Tools', ->
  first = (array) ->
    return unless array and array.length
    array[0]

  last = (array) ->
    return unless array and array.length
    array[array.length - 1]

  preventNaN = (v) ->
    if isNaN(v) then 0 else v

  first: first
  last: last
  preventNaN: preventNaN
