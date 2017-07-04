app.directive 'playersTable', ($window, $document, Tools) ->
  restrict: 'E'
  replace: true
  templateUrl: 'directives/players-table.html'
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

    $scope.prepareFullName = (fullName) -> Tools.transliterate fullName

    # Expand
    $scope.expandButtonClick = (player) ->
      isExpanded = $scope.expandedPlayers[player.fullName]

      if isExpanded
        _.unset $scope.expandedPlayers, player.fullName
      else
        $scope.expandedPlayers[player.fullName] = player.matchStats
      return

    # Season change
    $scope.$on 'seasonIsChanged', (event, seasonData) ->
      $scope.expandedPlayers = {}
      $scope.lastMatches = {}

      $scope.players = seasonData.players
        .filter (p) -> p.overallStats.games > 1
        .sort (a, b) ->
          d = a.overallStats.points - b.overallStats.points
          return d if d
          d = a.overallStats.pm - b.overallStats.pm
          return d if d
          d = a.overallStats.games - b.overallStats.games
          return d if d
          return -1 if a.lastName > b.lastName
          return 1 if a.lastName < b.lastName
          return -1 if a.firstName > b.firstName
          return 1 if a.firstName < b.firstName

      $scope.champion = Tools.last($scope.players).fullName

      for player in $scope.players
        pastMatches = player.matchStats.filter (m) -> m.matchData.date.isBefore()
        $scope.lastMatches[player.fullName] = _.takeRight pastMatches, 5
      return

    return
