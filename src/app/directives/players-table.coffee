app.directive 'playersTable', ->
  restrict: 'E'
  replace: true
  templateUrl: 'directives/players-table.html'
  scope:
    data: '='
    season: '='
  link: ($scope) ->
    return
