app.factory 'Tools', ($location) ->
  first = (array) ->
    return unless array and array.length
    array[0]

  last = (array) ->
    return unless array and array.length
    array[array.length - 1]

  preventNaN = (v) ->
    if isNaN(v) then 0 else v

  countCharOccurancies = (string, char) ->
    re = new RegExp char, 'g'
    (string.match(re) or []).length

  getUrlParameter = (parameter) ->
    $location.search()[parameter]

  setUrlParameter = (parameter, value) ->
    $location.search parameter, value
    return

  first: first
  last: last
  preventNaN: preventNaN
  getUrlParameter: getUrlParameter
  setUrlParameter: setUrlParameter
  countCharOccurancies: countCharOccurancies
