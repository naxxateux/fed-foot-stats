app.controller 'TableController', ($scope, Tabletop) ->
  Tabletop.then (ttdata) ->
    console.log ttdata
    return
  return
