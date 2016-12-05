app.directive 'matchCircle', ($rootScope) ->
  restrict: 'E'
  replace: true
  templateUrl: 'directives/match-circle.html'
  scope:
    match: '='
  link: ($scope) ->
    $scope.matchMouseEnter = ->
      $rootScope.$broadcast 'matchMouseEnter', $scope.match
      return

    $scope.matchMouseMove = ($event) ->
      $rootScope.$broadcast 'matchMouseMove', {x: $event.clientX, y: $event.clientY}
      return

    $scope.matchMouseLeave = ->
      $rootScope.$broadcast 'matchMouseLeave'
      return

    return
