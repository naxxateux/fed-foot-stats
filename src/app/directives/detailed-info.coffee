app.directive 'detailedInfo', ($rootScope) ->
  restrict: 'E'
  replace: true
  templateUrl: 'directives/detailed-info.html'
  scope:
    player: '='
  link: ($scope) ->
    return
