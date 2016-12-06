app.factory 'Tools', ($location, DICTIONARY) ->
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

  transliterate = (string) ->
    string
      .split ''
      .map (char) -> if char is ' ' then char else DICTIONARY[char] or ''
      .join ''

  first: first
  last: last
  preventNaN: preventNaN
  countCharOccurancies: countCharOccurancies
  getUrlParameter: getUrlParameter
  setUrlParameter: setUrlParameter
  transliterate: transliterate
