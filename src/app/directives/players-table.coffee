app.directive 'playersTable', ($window, $document, Tools) ->
  restrict: 'E'
  replace: true
  templateUrl: 'directives/players-table.html'
  scope:
    data: '='
    season: '='
  link: ($scope) ->
    # Sticky header
    $stickyHeaderContainer = $('.sticky-header-container')
    initialPos = $stickyHeaderContainer.offset().top

    angular
      .element $window
      .bind 'scroll', ->
        $scope.headerIsStuck = $document.scrollTop() > initialPos
        $scope.$apply()
        return

    # Sorting
    $scope.predicate = 'points'
    $scope.reverse = true

    $scope.sortableOnClick = (predicate) ->
      $scope.reverse = if $scope.predicate is predicate then not $scope.reverse else true
      $scope.predicate = predicate
      return

    # Get champion
    $scope.$watch 'season', ->
      $scope.players = $scope.data[$scope.season].players

      sortedTable = $scope.data[$scope.season].players.sort (a, b) ->
        return -1 if a.overallStats.points > b.overallStats.points
        return 1 if a.overallStats.points < b.overallStats.points
        return -1 if a.overallStats.games > b.overallStats.games
        return 1 if a.overallStats.games < b.overallStats.games
        0
      $scope.champion = Tools.first(sortedTable)?.fullName
      return

    return
