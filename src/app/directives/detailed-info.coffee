app.directive 'detailedInfo', ($rootScope) ->
  restrict: 'E'
  replace: true
  templateUrl: 'directives/detailed-info.html'
  scope:
    player: '='
  link: ($scope) ->
    $scope.monthNames = [
      'Январь'
      'Февраль'
      'Март'
      'Апрель'
      'Май'
      'Июнь'
      'Июль'
      'Август'
      'Сентябрь'
      'Октябрь'
      'Ноябрь'
      'Декабрь'
    ]

    $scope.getMonthMatches = (monthIndex) ->
      $scope.player.matchStats.filter (m) -> m.matchData.date.month() is monthIndex

    return
