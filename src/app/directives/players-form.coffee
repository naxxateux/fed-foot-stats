app.directive 'playerForm', ->
  restrict: 'E'
  replace: true
  templateUrl: 'directives/player-form.html'
  scope:
    matches: '='
  link: ($scope) ->
    return
