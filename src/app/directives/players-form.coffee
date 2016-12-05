app.directive 'playerForm', ($rootScope) ->
  restrict: 'E'
  replace: true
  templateUrl: 'directives/player-form.html'
  scope:
    matches: '='
  link: ($scope) ->
    $scope.matchMouseEnter = (match) ->
      $rootScope.$broadcast 'matchMouseEnter', match
      return

    $scope.matchMouseMove = ($event) ->
      $rootScope.$broadcast 'matchMouseMove', {x: $event.clientX, y: $event.clientY}
      return

    $scope.matchMouseLeave = ->
      $rootScope.$broadcast 'matchMouseLeave'
      return

    return
