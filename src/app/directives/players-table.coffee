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

    # Expand
    $scope.expandButtonClick = (index) ->
      isExpanded = $scope.expanded.indexOf(index) isnt -1

      if isExpanded
        _.pull $scope.expanded, index
      else
        $scope.expanded.push index
      return

    # Watchers
    $scope.$watch 'season', ->
      $scope.players = $scope.data[$scope.season].players.sort (a, b) ->
        d = a.overallStats.points - b.overallStats.points
        return d if d
        d = a.overallStats.games - b.overallStats.games
        return d if d
        d = a.overallStats.goals - b.overallStats.goals
        return d if d
        d = a.overallStats.assists - b.overallStats.assists
        return d if d
        return -1 if a.lastName > b.lastName
        return 1 if a.lastName < b.lastName
        return -1 if a.firstName > b.firstName
        return 1 if a.firstName < b.firstName

      $scope.champion = Tools.last($scope.players).fullName
      $scope.expanded = []
      return

    return
